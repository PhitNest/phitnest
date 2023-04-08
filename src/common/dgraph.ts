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
  operation: (client: DgraphClient) => Promise<T>
): Promise<T> {
  const client = new DgraphClient(new DgraphClientStub(dgraphHost));
  client.setDebugMode(process.env.NODE_ENV === "development");
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
