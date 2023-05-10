import { TranspileOptions } from "typescript";
import * as fs from "fs";
import * as path from "path";

export const tsconfig: TranspileOptions = JSON.parse(
  fs.readFileSync(path.join(process.cwd(), "tsconfig.json")).toString()
);
