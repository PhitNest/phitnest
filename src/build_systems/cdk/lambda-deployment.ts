import { TranspileOptions, transpileModule } from "typescript";
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
  ignoreTests = true
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
  sourcePath: string,
  outputDir: string,
  nodeModulesDir: string,
  commonDir: string
) {
  fs.mkdirSync(outputDir, { recursive: true });
  const outputPath = path.join(outputDir, "index.js");
  const source = fs.readFileSync(sourcePath);
  fs.writeFileSync(
    outputPath,
    transpileModule(source.toString(), tsconfig).outputText
  );
  fse.copySync(nodeModulesDir, path.join(outputDir, "node_modules"), {
    dereference: true,
  });
  fse.copySync(commonDir, path.join(outputDir, "api", "common"), {
    dereference: true,
  });
}
