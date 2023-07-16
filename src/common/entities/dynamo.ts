import { AttributeValue } from "@aws-sdk/client-dynamodb";
import { DynamoParseError } from "../utils";

/**
 * Each of these labels represents a type of data that can be stored in DynamoDB.
 */
type Label = "S" | "N" | "B" | "SS" | "NS" | "BS" | "BOOL" | "M" | "L" | "D";

/**
 * Given a type, T, this will return another Type based on the type of data that T represents.
 */
type AttributeVisitor<T, S, N, D, B, SS, NS, DS, BS, Bool, L, M> =
  T extends string
    ? S
    : T extends number
    ? N
    : T extends Date
    ? D
    : T extends Uint8Array
    ? B
    : T extends Set<string>
    ? SS
    : T extends Set<number>
    ? NS
    : T extends Set<Date>
    ? DS
    : T extends Set<Uint8Array>
    ? BS
    : T extends boolean
    ? Bool
    : T extends Array<unknown>
    ? L
    : M;

type SerializedAttribute<T> = AttributeVisitor<
  T,
  { S: T },
  { N: string },
  { N: string },
  { B: T },
  { SS: string[] },
  { NS: string[] },
  { NS: string[] },
  { BS: Uint8Array[] },
  { BOOL: T },
  T extends Array<infer U> ? { L: SerializedAttribute<U>[] } : never,
  { M: SerializedDynamo<T> }
>;

/**
 * This is the type that represents the serialized data that is stored in DynamoDB.
 */
export type SerializedDynamo<T> = {
  [Key in keyof T]: SerializedAttribute<T[Key]>;
};

type ParserLabel<T> = AttributeVisitor<
  T,
  "S",
  "N",
  "D",
  "B",
  "SS",
  "NS",
  "DS",
  "BS",
  "BOOL",
  T extends Array<infer U> ? [DynamoParser<U>] : never,
  DynamoParser<T>
>;

/**
 * This is the type that is used to parse the data returned from DynamoDB.
 */
export type DynamoParser<T> = {
  [Key in keyof T]: ParserLabel<T[Key]>;
};

/**
 * Given data returned from DynamoDB, this will parse it into the type that you specify.
 *
 * @param dynamo The data returned from DynamoDB.
 * @param parser The shape of the data that you want to parse.
 * @returns The parsed data.
 */
export function parseDynamo<T>(
  dynamo: Record<string, AttributeValue>,
  parser: DynamoParser<T>
): T | DynamoParseError {
  // Here we lose some type information on the parsing shape, but it's not a big deal. We can still
  // cast the results to the correct type. We can do some runtime validation to throw proper errors
  // if the data is not in the correct shape.
  return parseMap(dynamo, parser) as T | DynamoParseError;
}

function parseMap(
  dynamo: Record<string, AttributeValue>,
  parser: Record<string, unknown>
): Record<string, unknown> | DynamoParseError {
  const results: Record<string, unknown> = {};
  if (!parser) {
    return new DynamoParseError(
      `Dynamo parser not found for ${JSON.stringify(dynamo)}`
    );
  }
  for (const [key, type] of Object.entries(parser)) {
    const value = dynamo[key];
    if (!value) {
      return new DynamoParseError(
        `Dynamo key ${key} not found in ${JSON.stringify(dynamo)}`
      );
    }
    const parseResult = parseAttribute(value, type, key);
    if (parseResult instanceof DynamoParseError) {
      return parseResult;
    } else {
      results[key] = parseResult;
    }
  }
  return results;
}

function checkType(
  type: unknown,
  check: Label,
  key: string
): "CONVERT_TO_DATE" | "SUCCESS" | DynamoParseError {
  if ((check === "N" && type === "D") || (check === "NS" && type === "DS")) {
    return "CONVERT_TO_DATE";
  }
  if (
    type !== check &&
    ((check === "L" && !(type instanceof Array)) ||
      (check === "M" && typeof type !== "object"))
  ) {
    return new DynamoParseError(
      `Dynamo key: ${key} must be type ${check} but was type ${type}`
    );
  }
  return "SUCCESS";
}

function parseAttribute(
  dynamo: AttributeValue,
  type: unknown,
  key: string
): unknown {
  function check(check: Label) {
    return checkType(type, check, key);
  }
  return AttributeValue.visit<unknown>(dynamo, {
    S: (value) => {
      check("S");
      return value;
    },
    N: (value) => {
      const checkResult = check("N");
      const parsed = parseFloat(value);
      return checkResult === "CONVERT_TO_DATE" ? new Date(parsed) : parsed;
    },
    B: (value) => {
      check("B");
      return value;
    },
    SS: (value) => {
      check("SS");
      return new Set(value);
    },
    NS: (value) => {
      const checkResult = check("NS");
      return new Set<unknown>(
        checkResult === "CONVERT_TO_DATE"
          ? value.map((x) => new Date(parseFloat(x)))
          : value.map(parseFloat)
      );
    },
    BS: (value) => {
      check("BS");
      return new Set(value);
    },
    BOOL: (value) => {
      check("BOOL");
      return value;
    },
    L: (value) => {
      check("L");
      return value.map((item, index) =>
        parseAttribute(item, (type as Array<unknown>)[index], key)
      );
    },
    M: (value) => {
      check("M");
      return parseMap(value, type as Record<string, unknown>);
    },
    NULL: () => {
      return new DynamoParseError(`Dynamo ${key} must not be null`);
    },
    _: () => {
      return new DynamoParseError(`Dynamo ${key} must be a primitive`);
    },
  });
}
