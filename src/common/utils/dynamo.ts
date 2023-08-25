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
export type PartitionKey = { pk: string };

/**
 * Used to query one particular row only. Queries by equality on both PK and SK.
 */
export type RowKey = PartitionKey & { sk?: string };

/**
 * Allows you to query multiple rows at once. Queries by equality on PK and by operator on SK.
 */
export type MultiRowKey<Op extends SkOperator = SkOperator> = PartitionKey & {
  sk?: { q: string; op: Op };
};

/**
 * This allows you to provide a custom parser for the data returned from the database.
 */
export type ParseParams<T> = { parseShape: DynamoParser<T> };

/**
 * These params are used to put a new item into the database.
 */
export type PutParams = RowKey & { data: Record<string, AttributeValue> };

/**
 * These params are used to update an existing item in the database.
 */
export type UpdateParams = RowKey & {
  expression: string;
  varMap: Record<string, AttributeValue>;
};
/**
 * These params are used for multiple operations in a single transaction.
 */
export type TransactionParams = {
  updates?: UpdateParams[];
  puts?: PutParams[];
  deletes?: RowKey[];
};

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

function rowKey(key: RowKey): {
  pk: { S: string };
  sk?: { S: string };
} {
  return {
    pk: { S: key.pk },
    ...(key.sk ? { sk: { S: key.sk } } : {}),
  };
}

function queryCommand(
  key: MultiRowKey,
  projection?: string
): QueryCommandInput {
  return {
    TableName: process.env.DYNAMO_TABLE_NAME,
    KeyConditions: {
      pk: {
        ComparisonOperator: "EQ",
        AttributeValueList: [{ S: key.pk }],
      },
      ...(key.sk
        ? {
            sk: {
              ComparisonOperator: key.sk.op,
              AttributeValueList: [{ S: key.sk.q }],
            },
          }
        : {}),
    },
    ProjectionExpression: projection,
  };
}

function updateCommand(params: UpdateParams): UpdateItemCommandInput & {
  UpdateExpression: string;
} {
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
    Key: rowKey(params),
  };
}

type QueryResult<Op extends SkOperator> = Op extends "EQ"
  ? Record<string, AttributeValue> | ResourceNotFoundError
  : Record<string, AttributeValue>[];

type ParsedQueryResult<T, Op extends SkOperator> = Op extends "EQ"
  ? T | ResourceNotFoundError
  : T[];

class DynamoClient {
  private client: DynamoDBClient;

  constructor(client: DynamoDBClient) {
    this.client = client;
  }

  async update(params: UpdateParams): Promise<void> {
    await this.client.send(new UpdateItemCommand(updateCommand(params)));
  }

  async put(params: PutParams): Promise<void> {
    await this.client.send(new PutItemCommand(putCommand(params)));
  }

  async query<Op extends SkOperator>(
    key: MultiRowKey<Op>,
    projection?: string
  ): Promise<QueryResult<Op>> {
    return (await (async () => {
      try {
        const res = await this.client.send(
          new QueryCommand(queryCommand(key, projection))
        );
        if (key.sk && key.sk.op === "EQ") {
          if (res.Items && res.Items.length > 0) {
            return res.Items[0];
          } else {
            return new ResourceNotFoundError(key);
          }
        } else {
          return res.Items ?? [];
        }
      } catch {
        return new ResourceNotFoundError(key);
      }
    })()) as QueryResult<Op>;
  }

  async writeTransaction(params: TransactionParams): Promise<void> {
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
  ): Promise<ParsedQueryResult<T, Op>> {
    return (await (async () => {
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
        );
      } else {
        const parsed = (queryRes as Record<string, AttributeValue>[]).map(
          (item) => parseDynamo(item, params.parseShape)
        );
        return parsed;
      }
    })()) as ParsedQueryResult<T, Op>;
  }

  async delete(params: RowKey): Promise<void> {
    await this.client.send(new DeleteItemCommand(deleteCommand(params)));
  }
}

export function dynamo() {
  return new DynamoClient(
    new DynamoDBClient({
      region: process.env.AWS_REGION,
    })
  );
}
