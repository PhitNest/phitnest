import { HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import { getSharedTestDataDirectoryPath } from "../common/test-helpers";
import { getRoutesFromFilesystem } from "./phitnest-api-stack";
import * as fs from "fs";
import * as path from "path";

describe("getRoutesFromFilesystem", () => {
  it("should return all routes in a directory", () => {
    const apiRoutesDir = path.join(
      getSharedTestDataDirectoryPath(),
      "api_routes"
    );
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
      path: "route1",
      method: HttpMethod.GET,
      filesystemPath: path.parse(route1GetPath).dir,
    });
    expect(result).toContainEqual({
      path: "route2/subRoute",
      method: HttpMethod.GET,
      filesystemPath: path.parse(route2GetPath).dir,
    });
    expect(result).toContainEqual({
      path: "route1",
      method: HttpMethod.POST,
      filesystemPath: path.parse(route1PostPath).dir,
    });
    expect(result).toContainEqual({
      path: "route2/subRoute",
      method: HttpMethod.POST,
      filesystemPath: path.parse(route2PostPath).dir,
    });
    expect(result).toContainEqual({
      path: "",
      method: HttpMethod.POST,
      filesystemPath: apiRoutesDir,
    });
  });
});
