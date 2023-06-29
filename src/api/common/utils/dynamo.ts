import {
  AttributeValue,
  DynamoDBClient,
  PutItemCommand,
  PutItemCommandInput,
  QueryCommand,
  QueryCommandInput,
  TransactWriteItemsCommand,
  UpdateItemCommand,
  UpdateItemCommandInput,
  DeleteItemCommand,
  DeleteItemCommandInput,
} from "@aws-sdk/client-dynamodb";
import { DynamoShape, parseDynamo } from "../entities/dynamo";

export type SkOperator = "EQ" | "BEGINS_WITH" | "CONTAINS";

export type PartitionKey = {
  pk: string;
};

export type RowKey = PartitionKey & {
  sk?: string;
};

export type MultiRowKey<Op extends SkOperator = SkOperator> = PartitionKey & {
  sk?: { q: string; op: Op };
};

export type ParseParams<T> = {
  parseShape: DynamoShape<T>;
};

export type PutParams = RowKey & { data: Record<string, AttributeValue> };

export type UpdateParams<
  T extends Record<string, unknown>,
  VarNames extends `:${string}` | undefined
> = string extends keyof T
  ? never
  : RowKey & {
      expression: `SET ${Extract<keyof T, string>} = ${
        | `${Extract<keyof T, string> | number}${
            | ` ${"+" | "-" | "*" | "/"} ${Extract<VarNames, string> | number}`
            | ""}`
        | Extract<VarNames, string>
        | number}`;
    } & (VarNames extends undefined
        ? { varMap?: undefined }
        : {
            varMap: { [Key in Extract<VarNames, string>]: AttributeValue };
          });

export type TransactionParams<
  UpdateTypes extends Record<string, unknown> = Record<string, unknown>,
  UpdateVarNames extends `:${string}` | undefined = undefined
> = {
  updates: UpdateParams<UpdateTypes, UpdateVarNames>[];
  puts: PutParams[];
  deletes: RowKey[];
};

export type SingleOrPlural<T, Op extends SkOperator> = Op extends Exclude<
  SkOperator,
  "EQ"
>
  ? T[]
  : T;

export abstract class DynamoClient {
  abstract query<Op extends SkOperator>(
    params: MultiRowKey<Op>,
    projection?: string
  ): Promise<SingleOrPlural<Record<string, AttributeValue>, Op>>;

  abstract parsedQuery<T, Op extends SkOperator>(
    params: ParseParams<T> & MultiRowKey<Op>
  ): Promise<SingleOrPlural<T, Op>>;

  abstract update<
    UpdateTypes extends Record<string, unknown>,
    UpdateVarNames extends `:${string}` | undefined = undefined
  >(params: UpdateParams<UpdateTypes, UpdateVarNames>): Promise<void>;

  abstract writeTransaction<
    UpdateTypes extends Record<string, unknown> = Record<string, unknown>,
    UpdateVarNames extends `:${string}` | undefined = undefined
  >(params: TransactionParams<UpdateTypes, UpdateVarNames>): Promise<void>;

  abstract put(params: PutParams): Promise<void>;

  abstract delete(params: RowKey): Promise<void>;
}

export abstract class Dynamo {
  abstract connect(): DynamoClient;
}

function rowKey(key: RowKey): {
  part_id: { S: string };
  sort_id?: { S: string };
} {
  return {
    part_id: { S: key.pk },
    ...(key.sk ? { sort_id: { S: key.sk } } : {}),
  };
}

function queryCommand(
  key: MultiRowKey,
  projection?: string
): QueryCommandInput {
  return {
    TableName: process.env.DYNAMO_TABLE_NAME,
    KeyConditions: {
      part_id: {
        ComparisonOperator: "EQ",
        AttributeValueList: [{ S: key.pk }],
      },
      ...(key.sk
        ? {
            sort_id: {
              ComparisonOperator: key.sk.op,
              AttributeValueList: [{ S: key.sk.q }],
            },
          }
        : {}),
    },
    ProjectionExpression: projection,
  };
}

function updateCommand<
  UpdateTypes extends Record<string, unknown> = Record<string, unknown>,
  UpdateVarNames extends `:${string}` | undefined = undefined
>(
  params: UpdateParams<UpdateTypes, UpdateVarNames>
): UpdateItemCommandInput & { UpdateExpression: string } {
  return {
    TableName: process.env.DYNAMO_TABLE_NAME,
    Key: rowKey(params),
    UpdateExpression: params.expression,
    ExpressionAttributeValues: params.varMap,
  };
}

function putCommand(params: PutParams): PutItemCommandInput {
  return {
    TableName: process.env.DYNAMO_TABLE_NAME,
    Item: {
      ...rowKey(params),
      ...params.data,
    },
  };
}

function deleteCommand(params: RowKey): DeleteItemCommandInput {
  return {
    TableName: process.env.DYNAMO_TABLE_NAME,
    Key: {
      part_id: { S: params.pk },
      ...(params.sk ? { sort_id: { S: params.sk } } : {}),
    },
  };
}

class DynamoClientImpl extends DynamoClient {
  private client: DynamoDBClient;

  constructor(client: DynamoDBClient) {
    super();
    this.client = client;
  }

  async update<
    T extends Record<string, unknown>,
    VarNames extends `:${string}` | undefined = undefined
  >(params: UpdateParams<T, VarNames>): Promise<void> {
    await this.client.send(new UpdateItemCommand(updateCommand(params)));
  }

  async put(params: PutParams): Promise<void> {
    await this.client.send(new PutItemCommand(putCommand(params)));
  }

  async query<Op extends SkOperator>(
    key: MultiRowKey<Op>,
    projection?: string
  ): Promise<SingleOrPlural<Record<string, AttributeValue>, Op>> {
    const res = await this.client.send(
      new QueryCommand(queryCommand(key, projection))
    );
    if (key.sk && key.sk.op === "EQ") {
      if (res.Items) {
        return res.Items[0] as SingleOrPlural<
          Record<string, AttributeValue>,
          Op
        >;
      } else {
        throw {
          type: "ResourceNotFound",
          message: `Could not find item for query: ${JSON.stringify(key)}`,
        };
      }
    }
    return (res.Items ?? []) as SingleOrPlural<
      Record<string, AttributeValue>,
      Op
    >;
  }

  async writeTransaction<
    UpdateTypes extends Record<string, unknown> = Record<string, unknown>,
    UpdateVarNames extends `:${string}` | undefined = undefined
  >(params: TransactionParams<UpdateTypes, UpdateVarNames>): Promise<void> {
    await this.client.send(
      new TransactWriteItemsCommand({
        TransactItems: [
          ...Object.entries(params.updates ?? {}).map(([, update]) => ({
            Update: updateCommand(update),
          })),
          ...Object.entries(params.puts ?? {}).map(([, put]) => ({
            Put: putCommand(put),
          })),
          ...Object.entries(params.deletes ?? {}).map(([, deleter]) => ({
            Delete: deleteCommand(deleter),
          })),
        ],
      })
    );
  }

  async parsedQuery<T, Op extends SkOperator>(
    params: ParseParams<T> & MultiRowKey<Op>
  ): Promise<SingleOrPlural<T, Op>> {
    const queryRes = await this.query(
      params,
      Object.keys(params.parseShape).join(",")
    );
    return (
      params.sk && params.sk.op === "EQ"
        ? parseDynamo(
            queryRes as Record<string, AttributeValue>,
            params.parseShape
          )
        : (queryRes as Record<string, AttributeValue>[]).map((item) =>
            parseDynamo(item, params.parseShape)
          )
    ) as SingleOrPlural<T, Op>;
  }

  async delete(params: RowKey): Promise<void> {
    await this.client.send(new DeleteItemCommand(deleteCommand(params)));
  }
}

class DynamoImpl extends Dynamo {
  constructor() {
    super();
  }

  connect(): DynamoClient {
    return new DynamoClientImpl(
      new DynamoDBClient({
        region: process.env.AWS_REGION,
      })
    );
  }
}

let injectedDynamo: Dynamo = new DynamoImpl();

export function dynamo(): Dynamo {
  return injectedDynamo;
}

export function injectDynamo(newDynamo: Dynamo): void {
  injectedDynamo = newDynamo;
}
