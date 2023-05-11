import { HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import { getRoutesFromFilesystem } from "./file-based-routing";
import { getSharedTestDataPath } from "test-helpers";
import * as path from "path";
import * as fs from "fs";

describe("getRoutesFromFilesystem", () => {
  it("should return all routes in a directory", () => {
    // Define the directory to test, it is part of the shared test data
    const apiRoutesDir = getSharedTestDataPath("api_routes");

    // Define the expected routes and their filesystem paths
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

    // Ensure that all the expected files exist
    expect(fs.existsSync(route1GetPath));
    expect(fs.existsSync(route1PostPath));
    expect(fs.existsSync(route1UnknownPath));
    expect(fs.existsSync(route2GetPath));
    expect(fs.existsSync(route2PostPath));
    expect(fs.existsSync(rootPostPath));

    // Run the function `getRoutesFromFilesystem` on the test directory
    const result = getRoutesFromFilesystem(apiRoutesDir);

    // Assert that the result has the expected number of routes
    // Note that the route with the unknown HTTP method is not included
    expect(result).toHaveLength(5);

    // For each expected route, assert that the result includes a matching route
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
