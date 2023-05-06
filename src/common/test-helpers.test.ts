import { getTestFilePath, getTestDataDirectoryPath } from "./test-helpers";
import * as path from "path";

describe("getTestDataDirectoryPath", () => {
  it("should get the correct test data directory", () => {
    const result = getTestDataDirectoryPath();
    expect(
      result.includes(path.join("test_data", "common", "test-helpers.test.ts"))
    );
  });
});

describe("getTestFilePath", () => {
  it("should get the correct test file path", () => {
    const result = getTestFilePath("test_file.ts");
    expect(result).toEqual(
      path.join(getTestDataDirectoryPath(), "test_file.ts")
    );
  });
});
