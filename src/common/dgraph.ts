import { DgraphClientStub, DgraphClient, ERR_ABORTED } from "dgraph-js-http";

export async function useDgraph<T>(
  operation: (client: DgraphClient) => Promise<T>
): Promise<T> {
  const stub = new DgraphClientStub(
    `${
      (process.env.NODE_ENV != "development"
        ? process.env.DGRAPH_HOST
        : null) ?? "http://localhost"
    }:${process.env.DGRAPH_PORT ?? "8080"}`
  );
  const client = new DgraphClient(stub);
  try {
    return await operation(client);
  } catch (e) {
    if (e === ERR_ABORTED) {
      return await operation(client);
    } else {
      throw e;
    }
  }
}
