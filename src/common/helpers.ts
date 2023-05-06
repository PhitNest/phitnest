import * as fs from "fs";
import * as path from "path";

export function getFilesRecursive(dirName: string): string[] {
  const files: string[] = [];
  const items = fs.readdirSync(dirName, { withFileTypes: true });
  for (const item of items) {
    const filePath = path.join(dirName, item.name);
    if (item.isDirectory()) {
      files.push(...getFilesRecursive(filePath));
    } else {
      files.push(filePath);
    }
  }
  return files;
}

export function getProjectRoot(): string {
  return process.cwd();
}
