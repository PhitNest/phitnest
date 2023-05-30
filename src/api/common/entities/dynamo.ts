import { AttributeValue } from "@aws-sdk/client-dynamodb";

type PrimitiveLabel = "S" | "N" | "B" | "SS" | "NS" | "BS" | "BOOL";

type PrimitiveType =
  | string
  | number
  | Date
  | Uint8Array
  | Set<Uint8Array>
  | Set<string>
  | Set<number>
  | Set<Date>
  | boolean;

type GetAttributeValue<T> = T extends string
  ? { S: string }
  : T extends number | Date
  ? { N: string }
  : T extends Uint8Array
  ? { B: Uint8Array }
  : T extends Set<string>
  ? { SS: string[] }
  : T extends Set<number | Date>
  ? { NS: string[] }
  : T extends Set<Uint8Array>
  ? { BS: Uint8Array[] }
  : T extends boolean
  ? { BOOL: boolean }
  : T extends []
  ? { L: Dynamo<T>[] }
  : { M: Dynamo<T> };

export type Dynamo<T> = {
  [Key in keyof T]: GetAttributeValue<T[Key]>;
};

type GetPrimitiveLabel<T> = T extends string
  ? "S"
  : T extends number | Date
  ? "N"
  : T extends Uint8Array
  ? "B"
  : T extends Set<string>
  ? "SS"
  : T extends Set<number | Date>
  ? "NS"
  : T extends Set<Uint8Array>
  ? "BS"
  : T extends boolean
  ? "BOOL"
  : T extends []
  ? DynamoShape<T>[]
  : DynamoShape<T>;

export type DynamoShape<T> = {
  [Key in keyof T]: GetPrimitiveLabel<T[Key]>;
};

export function parseDynamo<T>(
  dynamo: Record<string, AttributeValue>,
  shape: DynamoShape<T>
): T {
  return parseAttribute(dynamo, shape) as T;
}

function parseAttribute(
  dynamo: Record<string, AttributeValue>,
  shape: Record<string, PrimitiveLabel | object>
): Record<string, PrimitiveType | object> {
  const results: Record<string, PrimitiveType | object> = {};
  for (const [key, type] of Object.entries(shape)) {
    function checkType(check: PrimitiveLabel) {
      if (type !== check) {
        throw new Error(`Dynamo ${key} must be ${check}`);
      }
    }

    const value = dynamo[key];
    if (!value) {
      throw new Error(`Dynamo ${key} not found`);
    }
    AttributeValue.visit<void>(value, {
      S: (value) => {
        checkType("S");
        results[key] = value;
      },
      N: (value) => {
        checkType("N");
        results[key] = parseFloat(value);
      },
      B: (value) => {
        checkType("B");
        results[key] = value;
      },
      SS: (value) => {
        checkType("SS");
        results[key] = new Set(value);
      },
      NS: (value) => {
        checkType("NS");
        results[key] = new Set(value.map(parseFloat));
      },
      BS: (value) => {
        checkType("BS");
        results[key] = new Set(value);
      },
      BOOL: (value) => {
        checkType("BOOL");
        results[key] = value;
      },
      L: (value) => {
        results[key] = value.map(
          (item) => parseAttribute({ x: item }, { x: type }).x
        );
      },
      M: (value) => {
        results[key] = parseAttribute(value, type as Record<string, object>);
      },
      NULL: () => {
        throw new Error(`Dynamo ${key} must not be null`);
      },
      _: () => {
        throw new Error(`Dynamo ${key} must be a primitive`);
      },
    });
  }
  return results;
}
