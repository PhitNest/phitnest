import * as fs from "fs";
import * as path from "path";

export function getFilesRecursive(dirName: string): string[] {
  return fs.readdirSync(dirName, { withFileTypes: true }).flatMap((item) => {
    const filePath = path.join(dirName, item.name);
    if (item.isDirectory()) {
      return getFilesRecursive(filePath);
    } else {
      return filePath;
    }
  });
}
