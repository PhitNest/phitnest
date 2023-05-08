import { getSharedTestDataPath } from "../../test-helpers";
import { getFilesRecursive } from "./helpers";
import * as path from "path";
import * as fs from "fs";

describe("getFilesRecursive", () => {
  it("should return all files in a directory recursively", () => {
    const apiRoutesDir = getSharedTestDataPath("api_routes");
    const rootPost = path.join(apiRoutesDir, "post.ts");
    const route1 = path.join(apiRoutesDir, "route1");
    const route1Get = path.join(route1, "get.js");
    const route1Post = path.join(route1, "post.ts");
    const route1Unknown = path.join(route1, "unknown.ts");
    const route2 = path.join(apiRoutesDir, "route2", "subRoute");
    const route2Get = path.join(route2, "get.ts");
    const route2Post = path.join(route2, "post.js");
    expect(fs.existsSync(rootPost));
    expect(fs.existsSync(route1Get));
    expect(fs.existsSync(route1Post));
    expect(fs.existsSync(route1Unknown));
    expect(fs.existsSync(route2Get));
    expect(fs.existsSync(route2Post));
    const result = getFilesRecursive(apiRoutesDir).filter(
      (file) => !file.includes("node_modules")
    );
    expect(result).toContainEqual(rootPost);
    expect(result).toContainEqual(route1Get);
    expect(result).toContainEqual(route1Post);
    expect(result).toContainEqual(route1Unknown);
    expect(result).toContainEqual(route2Get);
    expect(result).toContainEqual(route2Post);
  });
});
