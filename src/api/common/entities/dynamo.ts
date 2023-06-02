import { AttributeValue } from "@aws-sdk/client-dynamodb";

type Label = "S" | "N" | "B" | "SS" | "NS" | "BS" | "BOOL" | "M" | "L" | "D";

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

type GetAttributeValue<T> = AttributeVisitor<
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
  T extends Array<infer U> ? { L: GetAttributeValue<U>[] } : never,
  { M: Dynamo<T> }
>;

export type Dynamo<T> = {
  [Key in keyof T]: GetAttributeValue<T[Key]>;
};

type GetPrimitiveLabel<T> = AttributeVisitor<
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
  T extends Array<infer U> ? [DynamoShape<U>] : never,
  DynamoShape<T>
>;

export type DynamoShape<T> = {
  [Key in keyof T]: GetPrimitiveLabel<T[Key]>;
};

export function parseDynamo<T>(
  dynamo: Record<string, AttributeValue>,
  shape: DynamoShape<T>
): T {
  return parseMap(dynamo, shape) as T;
}

enum CheckTypeResult {
  convertToDate,
  success,
}

function checkType(type: unknown, check: Label, key: string): CheckTypeResult {
  if ((check === "N" && type === "D") || (check === "NS" && type === "DS")) {
    return CheckTypeResult.convertToDate;
  }
  if (
    type !== check &&
    ((check === "L" && !(type instanceof Array)) ||
      (check === "M" && typeof type !== "object"))
  ) {
    throw new Error(
      `Dynamo key: ${key} must be type ${check} but was type ${type}`
    );
  }
  return CheckTypeResult.success;
}

function parseMap(
  dynamo: Record<string, AttributeValue>,
  shape: Record<string, unknown>
): Record<string, unknown> {
  const results: Record<string, unknown> = {};
  for (const [key, type] of Object.entries(shape)) {
    const value = dynamo[key];
    if (!value) {
      throw new Error(`Dynamo ${key} not found`);
    }
    results[key] = parseAttribute(value, type, key);
  }
  return results;
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
      return checkResult === CheckTypeResult.convertToDate
        ? new Date(parsed)
        : parsed;
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
        checkResult === CheckTypeResult.convertToDate
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
      return value.map((item) =>
        parseAttribute(item, (type as Array<unknown>)[0], key)
      );
    },
    M: (value) => {
      check("M");
      return parseMap(value, type as Record<string, unknown>);
    },
    NULL: () => {
      throw new Error(`Dynamo ${key} must not be null`);
    },
    _: () => {
      throw new Error(`Dynamo ${key} must be a primitive`);
    },
  });
}
