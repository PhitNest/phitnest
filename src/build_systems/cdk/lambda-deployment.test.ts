import { HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import { transpileModule } from "typescript";
import {
  getSharedTestDataPath,
  getTestDataPath,
  getTestOutputPath,
} from "test-helpers";
import { tsconfig } from "./lambda-deployment";
import { createDeploymentPackage } from "./lambda-deployment";
import * as path from "path";
import * as fs from "fs";
import { getFilesRecursive } from "../utils/helpers";

describe("createDeploymentPackage", () => {
  it("should create a deployment package for a route", () => {
    const apiRouteAbsolutePath = getSharedTestDataPath("api_routes", "route1");
    const apiRouteRelativePath = path.relative(
      getSharedTestDataPath("api_routes"),
      apiRouteAbsolutePath
    );
    const nodeModulesDir = getSharedTestDataPath("api_routes", "node_modules");
    const commonDir = getTestDataPath("common");
    createDeploymentPackage(
      getTestOutputPath("deployment_packages"),
      {
        filesystemAbsolutePath: apiRouteAbsolutePath,
        filesystemRelativePath: apiRouteRelativePath,
        path: "/route1",
        method: HttpMethod.POST,
      },
      nodeModulesDir,
      commonDir
    );
    const outputPath = getTestOutputPath(
      "deployment_packages",
      "route1",
      "post"
    );
    const outputFilePath = path.join(outputPath, "index.js");
    expect(fs.existsSync(outputFilePath));
    const fileData = fs.readFileSync(outputFilePath).toString();
    const expectedFileData = transpileModule(
      fs.readFileSync(path.join(apiRouteAbsolutePath, "post.ts")).toString(),
      tsconfig
    ).outputText;
    expect(fileData).toEqual(expectedFileData);
    const copiedNodeModules = new Set(
      getFilesRecursive(path.join(outputPath, "node_modules")).map((file) =>
        fs.readFileSync(file).toString()
      )
    );
    const expectedNodeModules = new Set(
      getFilesRecursive(nodeModulesDir).map((file) =>
        fs.readFileSync(file).toString()
      )
    );
    expect(copiedNodeModules).toEqual(expectedNodeModules);
    const copiedCommonFiles = new Set(
      getFilesRecursive(path.join(outputPath, "common")).map((file) =>
        fs.readFileSync(file).toString()
      )
    );
    const expectedCommonFiles = new Set(
      getFilesRecursive(commonDir).map((file) =>
        fs.readFileSync(file).toString()
      )
    );
    expect(copiedCommonFiles).toEqual(expectedCommonFiles);
  });
});
