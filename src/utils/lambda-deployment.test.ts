import { transpileModule } from "typescript";
import {
  getSharedTestDataPath,
  getTestDataPath,
  getTestOutputPath,
} from "test-helpers";
import { tsconfig, createDeploymentPackage } from "./lambda-deployment";
import { getFilesRecursive } from "./file-based-routing";
import * as path from "path";
import * as fs from "fs";

describe("createDeploymentPackage", () => {
  it("should create a deployment package for a route", async () => {
    const sourcePath = getSharedTestDataPath("api_routes", "route1", "post.ts");
    const nodeModulesDir = getSharedTestDataPath("api_routes", "node_modules");
    const outputPath = getTestOutputPath("deployment_package");
    createDeploymentPackage(
      sourcePath,
      nodeModulesDir,
      getTestDataPath("common"),
      outputPath
    );
    const outputFilePath = path.join(outputPath, "index.js");
    expect(fs.existsSync(outputFilePath));
    const fileData = fs.readFileSync(outputFilePath, {
      encoding: "utf-8",
    });
    const expectedFileData = transpileModule(
      fs.readFileSync(sourcePath, {
        encoding: "utf-8",
      }),
      tsconfig
    ).outputText;
    expect(fileData).toEqual(expectedFileData);
    const nodeModulesOutput = path.join(outputPath, "node_modules");
    const copiedNodeModules = new Set(
      getFilesRecursive(nodeModulesOutput).map((file) => [
        path.relative(nodeModulesOutput, file),
        fs.readFileSync(file, { encoding: "utf-8" }),
      ])
    );
    const expectedNodeModules = new Set(
      getFilesRecursive(nodeModulesDir).map((file) => [
        path.relative(nodeModulesDir, file),
        fs.readFileSync(file, { encoding: "utf-8" }),
      ])
    );
    expect(copiedNodeModules).toEqual(expectedNodeModules);
    const commonOutput = path.join(outputPath, "common");
    const copiedCommonFiles = new Set(
      getFilesRecursive(commonOutput).map((file) => [
        path.relative(commonOutput, file),
        fs.readFileSync(file, { encoding: "utf-8" }),
      ])
    );
    const expectedCommon = getTestDataPath("expected_common_out");
    const expectedCommonFiles = new Set(
      getFilesRecursive(expectedCommon).map((file) => [
        path.relative(expectedCommon, file),
        fs.readFileSync(file, { encoding: "utf-8" }),
      ])
    );
    expect(copiedCommonFiles).toEqual(expectedCommonFiles);
  });
});
