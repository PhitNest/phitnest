import { transpileModule } from "typescript";
import {
  getSharedTestDataPath,
  getTestDataPath,
  getTestOutputPath,
} from "test-helpers";
import { tsconfig } from "./lambda-deployment";
import { createDeploymentPackage } from "./lambda-deployment";
import { getFilesRecursive } from "../utils/helpers";
import * as path from "path";
import * as fs from "fs";

describe("createDeploymentPackage", () => {
  it("should create a deployment package for a route", () => {
    const sourcePath = getSharedTestDataPath("api_routes", "route1", "post.ts");
    const nodeModulesDir = getSharedTestDataPath("api_routes", "node_modules");
    const commonDir = getTestDataPath("common");
    const outputPath = getTestOutputPath("deployment_package");
    createDeploymentPackage(sourcePath, outputPath, nodeModulesDir, commonDir);
    const outputFilePath = path.join(outputPath, "index.js");
    expect(fs.existsSync(outputFilePath));
    const fileData = fs.readFileSync(outputFilePath).toString();
    const expectedFileData = transpileModule(
      fs.readFileSync(sourcePath).toString(),
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
      getFilesRecursive(path.join(outputPath, "api", "common")).map((file) =>
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
