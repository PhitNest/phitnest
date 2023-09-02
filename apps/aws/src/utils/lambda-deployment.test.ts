import {
  getSharedTestDataPath,
  getTestDataPath,
  getTestOutputPath,
} from "jest-helpers/src/test-helpers";
import { createDeploymentPackage } from "./lambda-deployment";
import { getFilesRecursive } from "./file-based-routing";
import * as path from "path";
import * as fs from "fs";

describe("createDeploymentPackage", () => {
  it("should create a deployment package for a route", async () => {
    const apiRoutesData = getSharedTestDataPath("api_routes");
    const apiSrcDir = path.join(apiRoutesData, "src");
    const sourcePath = path.join(apiSrcDir, "route1", "post.ts");
    const nodeModulesDir = path.join(apiRoutesData, "node_modules");
    const outputPath = getTestOutputPath("deployment_package");
    createDeploymentPackage(
      sourcePath,
      nodeModulesDir,
      path.join(apiSrcDir, "common"),
      outputPath,
    );
    const outputFilePath = path.join(outputPath, "index.js");
    expect(fs.existsSync(outputFilePath));
    const nodeModulesOutput = path.join(outputPath, "node_modules");
    const copiedNodeModules = new Set(
      getFilesRecursive(nodeModulesOutput).map((file) =>
        path.relative(nodeModulesOutput, file),
      ),
    );
    const expectedNodeModules = new Set(
      getFilesRecursive(nodeModulesDir).map((file) =>
        path.relative(nodeModulesDir, file),
      ),
    );
    expect(copiedNodeModules).toEqual(expectedNodeModules);
    const commonOutput = path.join(outputPath, "common");
    const copiedCommonFiles = new Set(
      getFilesRecursive(commonOutput).map((file) =>
        path.relative(commonOutput, file),
      ),
    );
    const expectedCommon = getTestDataPath("expected_common_out");
    const expectedCommonFiles = new Set(
      getFilesRecursive(expectedCommon).map((file) =>
        path.relative(expectedCommon, file),
      ),
    );
    expect(copiedCommonFiles).toEqual(expectedCommonFiles);
  });
});
