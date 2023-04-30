import { DgraphClientStub, DgraphClient, ERR_ABORTED } from "dgraph-js-http";

export const dgraphHost =
  process.env.NODE_ENV === "test"
    ? "http://localhost:3080"
    : `http://${
        !!!process.env.DGRAPH_HOST || process.env.DGRAPH_HOST === ""
          ? "host.docker.internal"
          : process.env.DGRAPH_HOST
      }:${process.env.DGRAPH_PORT ?? "8080"}`;

export function anyOfText(predicateOrs: string[], text: string): string {
  if (predicateOrs.length === 0) return "";
  return `@filter(${predicateOrs
    .map((p) => `anyoftext(${p}, "${text}")`)
    .join(" OR ")})`;
}

export function allOfText(predicateAnds: string[], text: string): string {
  if (predicateAnds.length === 0) return "";
  return `@filter(${predicateAnds
    .map((p) => `alloftext(${p}, "${text}")`)
    .join(" AND ")})`;
}

export function anyOfTerms(predicateOrs: string[], text: string): string {
  if (predicateOrs.length === 0) return "";
  return `@filter(${predicateOrs
    .map((p) => `anyofterms(${p}, "${text}")`)
    .join(" OR ")})`;
}

export function allOfTerms(predicateAnds: string[], text: string): string {
  if (predicateAnds.length === 0) return "";
  return `@filter(${predicateAnds
    .map((p) => `allofterms(${p}, "${text}")`)
    .join(" AND ")})`;
}

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
