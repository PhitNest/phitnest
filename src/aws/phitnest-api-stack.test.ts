import {
  getTestFilePath,
  getTestDataDirectoryPath,
} from "../common/test-helpers";
import { getRoutes } from "./phitnest-api-stack";
import { HttpMethod } from "aws-cdk-lib/aws-lambda";
import * as fs from "fs";
import * as path from "path";

describe("getRoutes", () => {
  it("should return all routes in a directory", () => {
    const route1GetPath = path.join("route1", "get.js");
    const route1PostPath = path.join("route1", "post.ts");
    const route1UnknownPath = path.join("route1", "unknown.ts");
    const route2GetPath = path.join("route2", "subRoute", "get.ts");
    const route2PostPath = path.join("route2", "subRoute", "post.js");
    const rootPostPath = "post.js";
    expect(fs.existsSync(getTestFilePath(route1GetPath)));
    expect(fs.existsSync(getTestFilePath(route1PostPath)));
    expect(fs.existsSync(getTestFilePath(route1UnknownPath)));
    expect(fs.existsSync(getTestFilePath(route2GetPath)));
    expect(fs.existsSync(getTestFilePath(route2PostPath)));
    expect(fs.existsSync(getTestFilePath(rootPostPath)));
    const result = getRoutes(getTestDataDirectoryPath());
    expect(result).toHaveLength(5);
    expect(result).toContainEqual({
      path: "route1",
      method: HttpMethod.GET,
    });
    expect(result).toContainEqual({
      path: "route2/subRoute",
      method: HttpMethod.GET,
    });
    expect(result).toContainEqual({
      path: "route1",
      method: HttpMethod.POST,
    });
    expect(result).toContainEqual({
      path: "route2/subRoute",
      method: HttpMethod.POST,
    });
    expect(result).toContainEqual({
      path: "",
      method: HttpMethod.POST,
    });
  });
});
