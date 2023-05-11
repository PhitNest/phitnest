import { TranspileOptions, transpileModule } from "typescript";
import { Route } from "../utils/file-based-routing";
import { getFilesRecursive } from "../utils/helpers";
import * as path from "path";
import * as fse from "fs-extra";
import * as fs from "fs";

export const tsconfig: TranspileOptions = JSON.parse(
  fs.readFileSync(path.join(process.cwd(), "tsconfig.json")).toString()
);

export function transpileFiles(
  srcDir: string,
  outputDir: string,
  ignoreTests: boolean = true
) {
  for (const commonFile of getFilesRecursive(srcDir)) {
    if (
      commonFile.endsWith(".ts") &&
      !(ignoreTests && commonFile.endsWith(".test.ts"))
    ) {
      const relativePath = path.relative(srcDir, commonFile);
      const outputPath = path
        .join(outputDir, relativePath)
        .replace(/\.ts$/, ".js");
      const src = fs.readFileSync(commonFile).toString();
      const transpiledSrc = transpileModule(src, tsconfig).outputText;
      fs.mkdirSync(path.parse(outputPath).dir, { recursive: true });
      fs.writeFileSync(outputPath, transpiledSrc);
    }
  }
}

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
  fse.copySync(commonDir, path.join(packageDir, "api", "common"));
}
