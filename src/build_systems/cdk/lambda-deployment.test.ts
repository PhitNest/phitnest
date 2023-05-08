import { HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import { transpileModule } from "typescript";
import { getSharedTestDataPath, getTestOutputPath } from "../../test-helpers";
import { createDeploymentPackage, tsconfig } from "./lambda-deployment";
import * as path from "path";
import * as fs from "fs";
import { getFilesRecursive } from "../common/helpers";

describe("createDeploymentPackage", () => {
  it("should create a deployment package for a route", () => {
    const apiRouteAbsolutePath = getSharedTestDataPath("api_routes", "route1");
    const apiRouteRelativePath = path.relative(
      getSharedTestDataPath("api_routes"),
      apiRouteAbsolutePath
    );
    const nodeModulesDir = getSharedTestDataPath("api_routes", "node_modules");
    createDeploymentPackage(
      getTestOutputPath("deployment_packages"),
      {
        filesystemAbsolutePath: apiRouteAbsolutePath,
        filesystemRelativePath: apiRouteRelativePath,
        path: "/route1",
        method: HttpMethod.POST,
      },
      nodeModulesDir
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
  });
});
