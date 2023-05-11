import { getSharedTestDataPath } from "test-helpers";
import { getFilesRecursive } from "./helpers";
import * as path from "path";
import * as fs from "fs";

// This test is ran on the shared test data directory, api_routes
describe("getFilesRecursive", () => {
  it("should return all files in a directory recursively", () => {
    // Define the directory to test, it is part of the shared test data
    const apiRoutesDir = getSharedTestDataPath("api_routes");

    // Define the expected files in the directory
    const rootPost = path.join(apiRoutesDir, "post.ts");
    const route1 = path.join(apiRoutesDir, "route1");
    const route1Get = path.join(route1, "get.js");
    const route1Post = path.join(route1, "post.ts");
    const route1Unknown = path.join(route1, "unknown.ts");
    const route2 = path.join(apiRoutesDir, "route2", "subRoute");
    const route2Get = path.join(route2, "get.ts");
    const route2Post = path.join(route2, "post.js");

    // Ensure that all the expected files exist
    expect(fs.existsSync(rootPost));
    expect(fs.existsSync(route1Get));
    expect(fs.existsSync(route1Post));
    expect(fs.existsSync(route1Unknown));
    expect(fs.existsSync(route2Get));
    expect(fs.existsSync(route2Post));

    let result = getFilesRecursive(apiRoutesDir);

    // Assert that the result includes some node modules files
    expect(result.some((file) => file.includes("node_modules"))).toBe(true);

    // Filter out the node modules files so we can focus on the test data
    result = result.filter((file) => !file.includes("node_modules"));

    // Assert that the result includes all of the expected files
    expect(result).toContainEqual(rootPost);
    expect(result).toContainEqual(route1Get);
    expect(result).toContainEqual(route1Post);
    expect(result).toContainEqual(route1Unknown);
    expect(result).toContainEqual(route2Get);
    expect(result).toContainEqual(route2Post);
  });
});
