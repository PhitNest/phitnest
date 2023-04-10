import { dgraphHost, useDgraph } from "./common/dgraph";
import { APIError } from "dgraph-js-http";
import fs from "fs";
import fetch from "isomorphic-fetch";

beforeEach(async () => {
  const request = async () =>
    await (
      await fetch(`${dgraphHost}/admin/schema`, {
        method: "POST",
        body: fs.readFileSync("./schema.gql", "utf8"),
        headers: { "Content-Type": "application/graphql" },
      })
    ).json();
  let repeat = true;
  while (repeat) {
    repeat = false;
    await request().catch((err) => {
      if (err instanceof APIError) {
        repeat = true;
      } else {
        throw err;
      }
    });
  }
});

afterEach(async () => {
  await useDgraph(async (client) => {
    let repeat = true;
    while (repeat) {
      repeat = false;
      await client.alter({ dropAll: true }).catch((err) => {
        if (err instanceof APIError) {
          repeat = true;
        } else {
          throw err;
        }
      });
    }
  });
});
