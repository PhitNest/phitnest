import { getTestFilePath, getTestDataDirectoryPath } from "./test-helpers";
import { getFilesRecursive } from "./helpers";
import * as fs from "fs";

describe("getFilesRecursive", () => {
  it("should return all files in a directory recursively", () => {
    const file1Path = getTestFilePath("file1.ts");
    const file2Path = getTestFilePath("file2.js");
    const file3Path = getTestFilePath("subDir/file3.tsx");
    const file4Path = getTestFilePath("subDir/file4.png");
    expect(fs.existsSync(file1Path));
    expect(fs.existsSync(file2Path));
    expect(fs.existsSync(file3Path));
    expect(fs.existsSync(file4Path));
    const result = getFilesRecursive(getTestDataDirectoryPath());
    expect(result).toHaveLength(4);
    expect(result).toContainEqual(file1Path);
    expect(result).toContainEqual(file2Path);
    expect(result).toContainEqual(file3Path);
    expect(result).toContainEqual(file4Path);
  });
});
