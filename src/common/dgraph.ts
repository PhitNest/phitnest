import { DgraphClientStub, DgraphClient, ERR_ABORTED } from "dgraph-js-http";

export const dgraphHost =
  process.env.NODE_ENV === "test"
    ? "http://localhost:3080"
    : `http://${
        !!!process.env.DGRAPH_HOST || process.env.DGRAPH_HOST === ""
          ? "host.docker.internal"
          : process.env.DGRAPH_HOST
      }:${process.env.DGRAPH_PORT ?? "8080"}`;

export async function useDgraph<T>(
  operation: (client: DgraphHook) => Promise<T>
): Promise<T> {
  const hook = new DgraphHook(new DgraphClientStub(dgraphHost));
  try {
    return await operation(hook);
  } catch (e) {
    if (e === ERR_ABORTED) {
      return await operation(hook);
    } else {
      throw e;
    }
  }
}

type WithTypename<T> = T & { __typename: string };

type WithRelationships<
  T,
  Relationships extends keyof T | undefined = undefined
> = Relationships extends keyof T
  ? Omit<WithTypename<T>, Relationships> & {
      [K in Relationships]: SchemaType<Partial<T[Relationships]>>;
    }
  : WithTypename<T>;

export type SchemaType<
  T,
  Relationships extends keyof T | undefined = undefined
> =
  | WithRelationships<T, Relationships>
  | (WithRelationships<T, Relationships> & { uid: string });

function recursivePredicateMap(obj: any) {
  const typename = obj.__typename;
  if (typename) {
    if (typename == "Point") {
      return {
        type: "Point",
        coordinates: [obj.longitude, obj.latitude],
      };
    } else {
      const transformedObj: { [k: string]: any } = {};
      for (const [key, value] of Object.entries(obj)) {
        if (key !== "__typename") {
          if (key === "uid") {
            transformedObj[key] = value;
          } else {
            transformedObj[`${typename}.${key}`] = recursivePredicateMap(value);
          }
        }
      }
      return transformedObj;
    }
  } else {
    return obj;
  }
}

function recursiveReversePredicateMap(obj: any) {
  if (
    typeof obj === "string" ||
    typeof obj === "number" ||
    typeof obj === "boolean" ||
    typeof obj === "symbol"
  ) {
    return obj;
  }
  let isPoint: boolean | null = null;
  let typename: string | null = null;
  return Object.keys(obj).reduce((accumulator: any, key: string) => {
    if (key === "coordinates" || key === "type") {
      if (!isPoint) {
        isPoint = true;
        accumulator["__typename"] = "Point";
      }
      if (key === "coordinates") {
        if (obj[key].length !== 2) {
          throw new Error("Invalid coordinates");
        }
        accumulator["latitude"] = obj[key][1];
        accumulator["longitude"] = obj[key][0];
      }
    } else if (isPoint) {
      throw new Error("Invalid point");
    } else {
      isPoint = false;
      if (key === "uid") {
        accumulator["uid"] = obj[key];
      } else {
        const parts = key.split(".");
        const firstPart = parts.shift() || null;
        const predicate = parts.join(".");
        if (predicate) {
          if (typename) {
            if (typename !== firstPart) {
              throw new Error("Invalid typename");
            }
          } else {
            typename = firstPart;
            accumulator["__typename"] = firstPart;
          }
        }
        if (firstPart) {
          accumulator[predicate ?? firstPart] = fromPredicateMap(obj[key]);
        }
      }
    }
    return accumulator;
  }, {});
}

export function fromPredicateMap(obj: { [k: string]: any }) {
  return recursiveReversePredicateMap(obj);
}

export function toPredicateMap<
  T,
  Relationships extends keyof T | undefined = undefined
>(
  obj: SchemaType<T, Relationships>
): {
  [k: string]: any;
} {
  return recursivePredicateMap(obj);
}

class DgraphHook extends DgraphClient {
  setJson<T, Relationships extends keyof T | undefined = undefined>(
    obj: SchemaType<T, Relationships>
  ) {
    return this.newTxn().mutate({
      setJson: toPredicateMap(obj),
      commitNow: true,
    });
  }

  async getJson(query: string): Promise<{ [k: string]: any[] }> {
    return Object.fromEntries(
      Object.entries((await this.newTxn().query(query)).data as any).map(
        ([key, value]) => [
          key,
          (value as { [k: string]: any }[]).map((predicateMap) =>
            fromPredicateMap(predicateMap)
          ),
        ]
      )
    );
  }
}
