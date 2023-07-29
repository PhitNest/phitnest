import { AttributeValue } from "@aws-sdk/client-dynamodb";
import { parseDynamo } from "common/entities";
import {
  DynamoClient,
  DynamoConnection,
  MultiRowKey,
  ParseParams,
  PutParams,
  ResourceNotFoundError,
  RowKey,
  SingleOrPlural,
  SkOperator,
  TransactionParams,
  UpdateParams,
} from "common/utils";

export class DynamoClientMock extends DynamoClient {
  private table: Record<
    string,
    Array<{ sk: string | undefined; data: Record<string, AttributeValue> }>
  >;

  constructor() {
    super();
    this.table = {};
  }

  async query<Op extends SkOperator>(
    params: MultiRowKey<Op>,
    projection?: string
  ): Promise<
    SingleOrPlural<Record<string, AttributeValue>, Op> | ResourceNotFoundError
  > {
    const partition = this.table[params.pk];
    if (!partition) {
      if (params.sk) {
        return new ResourceNotFoundError(params);
      }
    }
    if (params.sk) {
      let entries:
        | {
            sk: string | undefined;
            data: Record<string, AttributeValue>;
          }[]
        | undefined = undefined;
      if (params.sk.op === "BEGINS_WITH") {
        entries = partition?.filter(
          (entry) => entry.sk?.substring(0, params.sk?.q.length)
        );
      } else if (params.sk.op === "CONTAINS") {
        entries = partition?.filter(
          (entry) => entry.sk?.includes(params.sk?.q ?? "")
        );
      }
      if (entries) {
        return entries.map((entry) =>
          Object.fromEntries(
            Object.entries(entry.data).filter(
              ([key]) => projection?.split(",").includes(key)
            )
          )
        ) as SingleOrPlural<Record<string, AttributeValue>, Op>;
      }
    }
    const entry = partition?.find((entry) => entry.sk === params.sk);
    if (entry) {
      return Object.fromEntries(
        Object.entries(entry.data).filter(
          ([key]) => projection?.split(",").includes(key)
        )
      ) as SingleOrPlural<Record<string, AttributeValue>, Op>;
    } else {
      return new ResourceNotFoundError(params);
    }
  }

  async delete(key: RowKey): Promise<void> {
    const partition = this.table[key.pk];
    if (partition) {
      const entry = partition.find((entry) => entry.sk === key.sk);
      if (entry) {
        partition.splice(partition.indexOf(entry), 1);
      }
    }
  }

  async parsedQuery<T, Op extends SkOperator>(
    params: ParseParams<T> & MultiRowKey<Op>
  ): Promise<SingleOrPlural<T, Op> | ResourceNotFoundError> {
    const res = await this.query(
      params,
      Object.keys(params.parseShape).join(",")
    );
    if (res instanceof ResourceNotFoundError) {
      return res;
    }
    if (!params.sk || params.sk.op === "EQ") {
      return parseDynamo(
        res as Record<string, AttributeValue>,
        params.parseShape
      ) as SingleOrPlural<T, Op>;
    } else {
      return (res as Record<string, AttributeValue>[]).map((item) =>
        parseDynamo(item, params.parseShape)
      ) as SingleOrPlural<T, Op>;
    }
  }

  async update<
    UpdateTypes extends Record<string, unknown>,
    UpdateVarNames extends `:${string}` | undefined = undefined,
  >(params: UpdateParams<UpdateTypes, UpdateVarNames>): Promise<void> {
    const partition = this.table[params.pk];
    if (partition) {
      const entry = partition.find((entry) => entry.sk === params.sk);
      if (entry) {
        const expr = params.expression;
        let tokens = expr.replace("SET ", "").split(" ");
        tokens = tokens.filter((token) => token !== "");
        const key = tokens[0];
        if (entry.data[key]) {
          if (tokens.length > 2) {
            const valueLeft = tokens[2];
            let finalValue: number | string;
            if (valueLeft.startsWith(":")) {
              if (params.varMap) {
                const attribute = params.varMap[valueLeft as `:${string}`];
                if (attribute) {
                  if (attribute.N || attribute.S) {
                    finalValue = (
                      attribute.N ? parseFloat(attribute.N) : attribute.S
                    ) as string | number;
                  } else {
                    throw {
                      type: "InvalidUpdateExpression",
                      message: `Invalid attribute: ${JSON.stringify(
                        attribute
                      )} in varMap: ${JSON.stringify(
                        params.varMap
                      )}, must be a number or string`,
                    };
                  }
                } else {
                  throw {
                    type: "InvalidUpdateExpression",
                    message: `Could not find attribute: ${valueLeft} in varMap: ${JSON.stringify(
                      params.varMap
                    )}`,
                  };
                }
              } else {
                throw {
                  type: "InvalidUpdateExpression",
                  message: `No varMap provided, but attribute: ${valueLeft} was found in expression: ${expr}`,
                };
              }
            } else {
              const parsedLeft = parseFloat(valueLeft);
              if (!isNaN(parsedLeft)) {
                finalValue = parsedLeft;
              } else if (entry.data[valueLeft]) {
                const attribute = entry.data[valueLeft];
                if (attribute.N || attribute.S) {
                  finalValue = (
                    attribute.N ? parseFloat(attribute.N) : attribute.S
                  ) as string | number;
                } else {
                  throw {
                    type: "InvalidUpdateExpression",
                    message: `Invalid attribute: ${JSON.stringify(
                      attribute
                    )} in varMap: ${JSON.stringify(
                      params.varMap
                    )}, must be a number or string`,
                  };
                }
              } else {
                throw {
                  type: "InvalidUpdateExpression",
                  message: `Could not find attribute: ${valueLeft} in entry: ${JSON.stringify(
                    entry.data
                  )}`,
                };
              }
            }
            Object.assign(
              entry.data[key],
              typeof finalValue === "string"
                ? { S: finalValue }
                : { N: finalValue.toString() }
            );
          } else {
            throw {
              type: "InvalidUpdateExpression",
              message: "Not enough tokens",
            };
          }
        } else {
          throw {
            type: "InvalidUpdateExpression",
            message: `Could not find key: ${key} on item: ${JSON.stringify(
              entry
            )}`,
          };
        }
      }
    }
  }

  async writeTransaction<
    UpdateTypes extends Record<string, unknown> = Record<string, unknown>,
    UpdateVarNames extends `:${string}` | undefined = undefined,
  >(params: TransactionParams<UpdateTypes, UpdateVarNames>): Promise<void> {
    for (const update of params.updates) {
      await this.update(update);
    }
    for (const put of params.puts) {
      await this.put(put);
    }
    for (const deleter of params.deletes) {
      await this.delete(deleter);
    }
  }

  async put(params: PutParams): Promise<void> {
    let partition = this.table[params.pk];
    if (!partition) {
      partition = [];
      this.table[params.pk] = partition;
    }
    const entry = partition.find((entry) => entry.sk === params.sk);
    if (entry) {
      Object.assign(entry.data, params.data);
    } else {
      partition.push({ sk: params.sk, data: params.data });
    }
  }
}

export class DynamoMock extends DynamoConnection {
  client: DynamoClientMock;

  constructor() {
    super();
    this.client = new DynamoClientMock();
  }

  connect(): DynamoClientMock {
    return this.client;
  }
}
