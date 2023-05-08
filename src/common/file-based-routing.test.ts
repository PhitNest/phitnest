import { HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import {
  createDeploymentPackage,
  getRoutesFromFilesystem,
} from "./file-based-routing";
import { getSharedTestDataPath, getTestOutputPath } from "./test-helpers";
import * as path from "path";
import * as fs from "fs";

describe("createDeploymentPackage", () => {
  const apiRouteAbsolutePath = getSharedTestDataPath("api_routes", "route1");
  const apiRouteRelativePath = path.relative(
    getSharedTestDataPath("api_routes"),
    apiRouteAbsolutePath
  );
  createDeploymentPackage(getTestOutputPath("deployment_packages"), {
    filesystemAbsolutePath: apiRouteAbsolutePath,
    filesystemRelativePath: apiRouteRelativePath,
    path: "/route1",
    method: HttpMethod.POST,
  });
  expect(
    fs.existsSync(
      getTestOutputPath("deployment_packages", "route1", "post", "index.ts")
    )
  );
});

describe("getRoutesFromFilesystem", () => {
  it("should return all routes in a directory", () => {
    const apiRoutesDir = getSharedTestDataPath("api_routes");
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
    const route1GetAbsolutePath = path.parse(route1GetPath).dir;
    expect(result).toContainEqual({
      path: "/route1",
      method: HttpMethod.GET,
      filesystemAbsolutePath: route1GetAbsolutePath,
      filesystemRelativePath: path.relative(
        apiRoutesDir,
        route1GetAbsolutePath
      ),
    });
    const route2GetAbsolutePath = path.parse(route2GetPath).dir;
    expect(result).toContainEqual({
      path: "/route2/subRoute",
      method: HttpMethod.GET,
      filesystemAbsolutePath: route2GetAbsolutePath,
      filesystemRelativePath: path.relative(
        apiRoutesDir,
        route2GetAbsolutePath
      ),
    });
    const route1PostAbsolutePath = path.parse(route1PostPath).dir;
    expect(result).toContainEqual({
      path: "/route1",
      method: HttpMethod.POST,
      filesystemAbsolutePath: route1PostAbsolutePath,
      filesystemRelativePath: path.relative(
        apiRoutesDir,
        route1PostAbsolutePath
      ),
    });
    const route2PostAbsolutePath = path.parse(route2PostPath).dir;
    expect(result).toContainEqual({
      path: "/route2/subRoute",
      method: HttpMethod.POST,
      filesystemAbsolutePath: route2PostAbsolutePath,
      filesystemRelativePath: path.relative(
        apiRoutesDir,
        route2PostAbsolutePath
      ),
    });
    expect(result).toContainEqual({
      path: "/",
      method: HttpMethod.POST,
      filesystemAbsolutePath: apiRoutesDir,
      filesystemRelativePath: "",
    });
  });
});
