import { HttpMethod } from "aws-cdk-lib/aws-lambda";
import { getSharedTestDataPath } from "../test-helpers";
import {
  getFilesRecursive,
  getRoutesFromFilesystem,
} from "./file-based-routing";
import * as path from "path";
import * as fs from "fs";

interface TestPaths {
  rootPost: string;
  route1Get: string;
  route1Post: string;
  route1Unknown: string;
  route2Get: string;
  route2Post: string;
}

function getTestPaths(apiRoutesDir: string): TestPaths {
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

  return {
    rootPost: rootPost,
    route1Get: route1Get,
    route1Post: route1Post,
    route1Unknown: route1Unknown,
    route2Get: route2Get,
    route2Post: route2Post,
  };
}

// This test is ran on the shared test data directory, api_routes
describe("getFilesRecursive", () => {
  it("should return all files in a directory recursively", () => {
    // Define the directory to test, it is part of the shared test data
    const apiRoutesDir = getSharedTestDataPath("api_routes");

    const {
      route1Post,
      rootPost,
      route1Get,
      route1Unknown,
      route2Get,
      route2Post,
    } = getTestPaths(apiRoutesDir);

    const result = getFilesRecursive(apiRoutesDir);

    // Assert that the result includes all of the expected files
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
    // Define the directory to test, it is part of the shared test data
    const apiRoutesDir = getSharedTestDataPath("api_routes");

    const { route1Post, route1Get, route2Get, route2Post } =
      getTestPaths(apiRoutesDir);

    // Run the function `getRoutesFromFilesystem` on the test directory
    const result = getRoutesFromFilesystem(apiRoutesDir);

    // Assert that the result has the expected number of routes
    // Note that the route with the unknown HTTP method is not included
    expect(result).toHaveLength(5);

    // For each expected route, assert that the result includes a matching route
    const route1GetAbsolutePath = path.parse(route1Get).dir;
    expect(result).toContainEqual({
      path: "/route1",
      method: HttpMethod.GET,
      filesystemAbsolutePath: route1GetAbsolutePath,
      filesystemRelativePath: path.relative(
        apiRoutesDir,
        route1GetAbsolutePath
      ),
    });

    const route2GetAbsolutePath = path.parse(route2Get).dir;
    expect(result).toContainEqual({
      path: "/route2/subRoute",
      method: HttpMethod.GET,
      filesystemAbsolutePath: route2GetAbsolutePath,
      filesystemRelativePath: path.relative(
        apiRoutesDir,
        route2GetAbsolutePath
      ),
    });

    const route1PostAbsolutePath = path.parse(route1Post).dir;
    expect(result).toContainEqual({
      path: "/route1",
      method: HttpMethod.POST,
      filesystemAbsolutePath: route1PostAbsolutePath,
      filesystemRelativePath: path.relative(
        apiRoutesDir,
        route1PostAbsolutePath
      ),
    });

    const route2PostAbsolutePath = path.parse(route2Post).dir;
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
