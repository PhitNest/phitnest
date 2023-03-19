import dgraph from "dgraph-js-http";

export async function useDgraph<T>(
  operation: (client: dgraph.DgraphClient) => Promise<T>
): Promise<T> {
  const stub = new dgraph.DgraphClientStub(
    `${
      (process.env.NODE_ENV != "development"
        ? process.env.DGRAPH_HOST
        : null) ?? "localhost"
    }:8080`
  );
  const client = new dgraph.DgraphClient(stub);
  try {
    return await operation(client);
  } catch (e) {
    if (e === dgraph.ERR_ABORTED) {
      return await operation(client);
    } else {
      throw e;
    }
  }
}
