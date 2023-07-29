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
import { DynamoParser, parseDynamo } from "../entities/dynamo";
import { RequestError } from "./request-handling";

/**
 * These are the operators that you can use to query the database. (Used on SK field)
 */
export type SkOperator = "EQ" | "BEGINS_WITH" | "CONTAINS";

/**
 * This key is can be queried based only on equality, unlike the SK which can be queried with operators.
 */
export type PartitionKey = {
  pk: string;
};

/**
 * Used to query one particular row only. Queries by equality on both PK and SK.
 */
export type RowKey = PartitionKey & {
  sk?: string;
};

/**
 * Allows you to query multiple rows at once. Queries by equality on PK and by operator on SK.
 */
export type MultiRowKey<Op extends SkOperator = SkOperator> = PartitionKey & {
  sk?: { q: string; op: Op };
};

/**
 * This allows you to provide a custom parser for the data returned from the database.
 */
export type ParseParams<T> = {
  parseShape: DynamoParser<T>;
};

/**
 * These params are used to put a new item into the database.
 */
export type PutParams = RowKey & { data: Record<string, AttributeValue> };

/**
 * This represents a symbol that can be used in an update expression.
 */
type UpdateExpressionSymbol<
  T extends Record<string, unknown>,
  VarNames extends `:${string}` | undefined,
> = Extract<keyof T, string> | Extract<VarNames, string> | number;

/**
 * This represents an update expression that can be used in an update query.
 */
export type UpdateExpression<
  T extends Record<string, unknown>,
  VarNames extends `:${string}` | undefined,
> = `SET ${Extract<keyof T, string>} = ${`${UpdateExpressionSymbol<
  T,
  VarNames
>}${` ${"+" | "-" | "*" | "/"} ${UpdateExpressionSymbol<T, VarNames>}` | ""}`}`;

/**
 * These params are used to update an existing item in the database.
 */
export type UpdateParams<
  T extends Record<string, unknown>,
  VarNames extends `:${string}` | undefined,
> = string extends keyof T
  ? never
  : RowKey & {
      expression: UpdateExpression<T, VarNames>;
    } & (VarNames extends undefined
        ? { varMap?: undefined }
        : {
            varMap: { [Key in Extract<VarNames, string>]: AttributeValue };
          });

/**
 * These params are used for multiple operations in a single transaction.
 */
export type TransactionParams<
  UpdateTypes extends Record<string, unknown> = Record<string, unknown>,
  UpdateVarNames extends `:${string}` | undefined = undefined,
> = {
  updates: UpdateParams<UpdateTypes, UpdateVarNames>[];
  puts: PutParams[];
  deletes: RowKey[];
};

/**
 * This is a type that represents either a single item or an array of items.
 */
export type SingleOrPlural<T, Op extends SkOperator> = Op extends Exclude<
  SkOperator,
  "EQ"
>
  ? T[]
  : T;

export class ResourceNotFoundError extends RequestError {
  constructor(key: RowKey | MultiRowKey) {
    super(
      "ResourceNotFound",
      `Could not find item for query: ${JSON.stringify(key)}`
    );
  }
}

export class DynamoParseError extends RequestError {
  constructor(message: string) {
    super("DynamoParseError", message);
  }
}

/**
 * This is the DynamoClient interface. It is used to query the database.
 */
export abstract class DynamoClient {
  abstract query<Op extends SkOperator>(
    params: MultiRowKey<Op>,
    projection?: string
  ): Promise<
    SingleOrPlural<Record<string, AttributeValue>, Op> | ResourceNotFoundError
  >;

  abstract parsedQuery<T, Op extends SkOperator>(
    params: ParseParams<T> & MultiRowKey<Op>
  ): Promise<SingleOrPlural<T, Op> | ResourceNotFoundError>;

  abstract update<
    UpdateTypes extends Record<string, unknown>,
    UpdateVarNames extends `:${string}` | undefined = undefined,
  >(params: UpdateParams<UpdateTypes, UpdateVarNames>): Promise<void>;

  abstract writeTransaction<
    UpdateTypes extends Record<string, unknown> = Record<string, unknown>,
    UpdateVarNames extends `:${string}` | undefined = undefined,
  >(params: TransactionParams<UpdateTypes, UpdateVarNames>): Promise<void>;

  abstract put(params: PutParams): Promise<void>;

  abstract delete(params: RowKey): Promise<void>;
}

export abstract class DynamoConnection {
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
  UpdateVarNames extends `:${string}` | undefined = undefined,
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
    VarNames extends `:${string}` | undefined = undefined,
  >(params: UpdateParams<T, VarNames>): Promise<void> {
    await this.client.send(new UpdateItemCommand(updateCommand(params)));
  }

  async put(params: PutParams): Promise<void> {
    await this.client.send(new PutItemCommand(putCommand(params)));
  }

  async query<Op extends SkOperator>(
    key: MultiRowKey<Op>,
    projection?: string
  ): Promise<
    SingleOrPlural<Record<string, AttributeValue>, Op> | ResourceNotFoundError
  > {
    try {
      const res = await this.client.send(
        new QueryCommand(queryCommand(key, projection))
      );
      if (key.sk && key.sk.op === "EQ") {
        if (res.Items && res.Items.length > 0) {
          return res.Items[0] as SingleOrPlural<
            Record<string, AttributeValue>,
            Op
          >;
        } else {
          return new ResourceNotFoundError(key);
        }
      } else {
        return (res.Items ?? []) as SingleOrPlural<
          Record<string, AttributeValue>,
          Op
        >;
      }
    } catch {
      return new ResourceNotFoundError(key);
    }
  }

  async writeTransaction<
    UpdateTypes extends Record<string, unknown> = Record<string, unknown>,
    UpdateVarNames extends `:${string}` | undefined = undefined,
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
  ): Promise<SingleOrPlural<T, Op> | ResourceNotFoundError> {
    const queryRes = await this.query(
      params,
      Object.keys(params.parseShape).join(",")
    );
    if (queryRes instanceof ResourceNotFoundError) {
      return queryRes;
    }
    if (params.sk && params.sk.op === "EQ") {
      return parseDynamo(
        queryRes as Record<string, AttributeValue>,
        params.parseShape
      ) as SingleOrPlural<T, Op> | DynamoParseError;
    } else {
      const parsed = (queryRes as Record<string, AttributeValue>[]).map(
        (item) => parseDynamo(item, params.parseShape)
      );
      if (parsed.some((item) => item instanceof DynamoParseError)) {
        return parsed[
          parsed.findIndex((item) => item instanceof DynamoParseError)
        ] as DynamoParseError;
      } else {
        return parsed as SingleOrPlural<T, Op>;
      }
    }
  }

  async delete(params: RowKey): Promise<void> {
    await this.client.send(new DeleteItemCommand(deleteCommand(params)));
  }
}

class DynamoConnectionImpl extends DynamoConnection {
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

let injectedDynamo: DynamoConnection = new DynamoConnectionImpl();

export function dynamo(): DynamoConnection {
  return injectedDynamo;
}

export function injectDynamo(newDynamo: DynamoConnection): void {
  injectedDynamo = newDynamo;
}
