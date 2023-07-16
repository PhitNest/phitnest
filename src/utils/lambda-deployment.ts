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

function resolveRelativePaths(src: string): string {
  return src.replace('from "common', 'from "./common');
}

export function transpileFiles(
  srcDir: string,
  outputDir: string,
  ignoreTests = true
) {
  for (const file of getFilesRecursive(srcDir)) {
    if (file.endsWith(".ts") && !(ignoreTests && file.endsWith(".test.ts"))) {
      const relativePath = path.relative(srcDir, file);
      const outputPath = path
        .join(outputDir, relativePath)
        .replace(/\.ts$/, ".js");
      const src = fs.readFileSync(file, { encoding: "utf-8" });
      const transpiledSrc = transpileModule(
        resolveRelativePaths(src),
        tsconfig
      ).outputText;
      fs.mkdirSync(path.parse(outputPath).dir, { recursive: true });
      fs.writeFileSync(outputPath, transpiledSrc);
    }
  }
}

export function createDeploymentPackage(
  sourcePath: string,
  lockPath: string,
  nodeModulesDir: string,
  commonDir: string,
  outputDir: string
) {
  fs.mkdirSync(outputDir, { recursive: true });
  const source = fs.readFileSync(sourcePath, { encoding: "utf-8" });
  fs.writeFileSync(
    path.join(outputDir, "index.js"),
    transpileModule(resolveRelativePaths(source), tsconfig).outputText
  );
  fse.copySync(nodeModulesDir, path.join(outputDir, "node_modules"), {
    dereference: true,
  });
  fse.copySync(lockPath, path.join(outputDir, "package-lock.json"));
  transpileFiles(commonDir, path.join(outputDir, "common"));
}
