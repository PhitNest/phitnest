import { TranspileOptions, transpileModule } from "typescript";
import { Route } from "../common/file-based-routing";
import * as path from "path";
import * as fse from "fs-extra";
import * as fs from "fs";

export const tsconfig: TranspileOptions = JSON.parse(
  fs.readFileSync(path.join(process.cwd(), "tsconfig.json")).toString()
);

export function createDeploymentPackage(
  outputDir: string,
  route: Route,
  nodeModulesDir: string,
  commonDir: string
) {
  const packageDir = path.join(
    outputDir,
    route.filesystemRelativePath,
    route.method.toLowerCase()
  );
  fs.mkdirSync(packageDir, { recursive: true });
  const outputPath = path.join(packageDir, "index.js");
  const source = fs.readFileSync(
    path.join(route.filesystemAbsolutePath, `${route.method.toLowerCase()}.ts`)
  );
  fs.writeFileSync(
    outputPath,
    transpileModule(source.toString(), tsconfig).outputText
  );
  fse.copySync(nodeModulesDir, path.join(packageDir, "node_modules"));
  fse.copySync(commonDir, path.join(packageDir, "common"));
}
