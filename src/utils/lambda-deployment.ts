import { TranspileOptions, transpileModule } from "typescript";
import { getFilesRecursive } from "./file-based-routing";
import * as path from "path";
import * as fse from "fs-extra";
import * as fs from "fs";

export const tsconfig: TranspileOptions = JSON.parse(
  fs.readFileSync(path.join(process.cwd(), "tsconfig.json"), {
    encoding: "utf-8",
  })
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
      const src = fs.readFileSync(commonFile, { encoding: "utf-8" });
      const transpiledSrc = transpileModule(src, tsconfig).outputText;
      fs.mkdirSync(path.parse(outputPath).dir, { recursive: true });
      fs.writeFileSync(outputPath, transpiledSrc);
    }
  }
}

export function createDeploymentPackage(
  sourcePath: string,
  nodeModulesDir: string,
  commonDir: string,
  outputDir: string
) {
  fs.mkdirSync(outputDir, { recursive: true });
  const source = fs.readFileSync(sourcePath, { encoding: "utf-8" });
  fs.writeFileSync(
    path.join(outputDir, "index.js"),
    transpileModule(source, tsconfig).outputText
  );
  fse.copySync(nodeModulesDir, path.join(outputDir, "node_modules"), {
    dereference: true,
  });
  transpileFiles(commonDir, path.join(outputDir, "common"));
}
