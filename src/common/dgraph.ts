import { DgraphClientStub, DgraphClient, ERR_ABORTED } from "dgraph-js-http";

export const dgraphHost =
  process.env.NODE_ENV === "test"
    ? "http://localhost:3080"
    : `${process.env.DGRAPH_HOST ?? "http://localhost"}:${
        process.env.DGRAPH_PORT ?? "8080"
      }`;

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

export function toPredicateMap(obj: any & { __typename: string }): {
  [k: string]: any;
} {
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
          transformedObj[`${typename}.${key}`] = toPredicateMap(value);
        }
      }
      return transformedObj;
    }
  } else {
    return obj;
  }
}

class DgraphHook extends DgraphClient {
  setJson(obj: any & { __typename: string }) {
    return this.newTxn().mutate({
      setJson: toPredicateMap(obj),
      commitNow: true,
    });
  }
}
