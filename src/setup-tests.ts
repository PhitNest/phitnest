import { dgraphHost, useDgraph } from "./common/dgraph";
import fs from "fs";
import fetch from "cross-fetch";

const success = {
  data: {
    code: "Success",
    message: "Done",
  },
};

beforeEach(async () => {
  const request = async () =>
    await (
      await fetch(`${dgraphHost}/admin/schema`, {
        method: "POST",
        body: fs.readFileSync("./schema.gql", "utf8"),
        headers: { "Content-Type": "application/graphql" },
      })
    ).json();
  try {
    await request();
  } catch (err) {
    await expect(request()).resolves.toEqual(success);
  }
});

afterEach(async () => {
  await useDgraph(async (hook) => {
    const request = () => hook.alter({ dropAll: true });
    try {
      await request();
    } catch (err) {
      await expect(request()).resolves.toEqual(success);
    }
  });
});
