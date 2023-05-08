import { HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import {
  getFilesRecursive,
  getRoutesFromFilesystem,
} from "./file-based-routing";
import * as path from "path";
import * as fs from "fs";
import { getSharedTestFilePath } from "./test-helpers";

describe("getFilesRecursive", () => {
  it("should return all files in a directory recursively", () => {
    const apiRoutesDir = getSharedTestFilePath("api_routes");
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
    const result = getFilesRecursive(apiRoutesDir);
    expect(result).toHaveLength(6);
    expect(result).toContainEqual(rootPost);
    expect(result).toContainEqual(route1Get);
    expect(result).toContainEqual(route1Post);
    expect(result).toContainEqual(route1Unknown);
    expect(result).toContainEqual(route2Get);
    expect(result).toContainEqual(route2Post);
  });
});

describe("getRoutesFromFilesystem", () => {
  it("should return all routes in a directory", () => {
    const apiRoutesDir = getSharedTestFilePath("api_routes");
    const route1GetPath = path.join(apiRoutesDir, "route1", "get.js");
    const route1PostPath = path.join(apiRoutesDir, "route1", "post.ts");
    const route1UnknownPath = path.join(apiRoutesDir, "route1", "unknown.ts");
    const route2GetPath = path.join(
      apiRoutesDir,
      "route2",
      "subRoute",
      "get.ts"
    );
    const route2PostPath = path.join(
      apiRoutesDir,
      "route2",
      "subRoute",
      "post.js"
    );
    const rootPostPath = path.join(apiRoutesDir, "post.js");
    expect(fs.existsSync(route1GetPath));
    expect(fs.existsSync(route1PostPath));
    expect(fs.existsSync(route1UnknownPath));
    expect(fs.existsSync(route2GetPath));
    expect(fs.existsSync(route2PostPath));
    expect(fs.existsSync(rootPostPath));
    const result = getRoutesFromFilesystem(apiRoutesDir);
    expect(result).toHaveLength(5);
    expect(result).toContainEqual({
      path: "/route1",
      method: HttpMethod.GET,
      filesystemPath: path.parse(route1GetPath).dir,
    });
    expect(result).toContainEqual({
      path: "/route2/subRoute",
      method: HttpMethod.GET,
      filesystemPath: path.parse(route2GetPath).dir,
    });
    expect(result).toContainEqual({
      path: "/route1",
      method: HttpMethod.POST,
      filesystemPath: path.parse(route1PostPath).dir,
    });
    expect(result).toContainEqual({
      path: "/route2/subRoute",
      method: HttpMethod.POST,
      filesystemPath: path.parse(route2PostPath).dir,
    });
    expect(result).toContainEqual({
      path: "/",
      method: HttpMethod.POST,
      filesystemPath: apiRoutesDir,
    });
  });
});
