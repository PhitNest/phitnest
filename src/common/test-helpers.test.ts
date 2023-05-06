import { getProjectRoot } from "./helpers";
import {
  getTestFilePath,
  getTestDataDirectoryPath,
  getSharedTestDataDirectoryPath,
  TEST_OUTPUT_DIRECTORY_PATH,
  SHARED_TEST_DATA_DIRECTORY_PATH,
} from "./test-helpers";
import * as path from "path";

describe("getTestDataDirectoryPath", () => {
  it("should get the correct test data directory", () => {
    const result = getTestDataDirectoryPath();
    expect(result).toEqual(
      path.join(
        getProjectRoot(),
        TEST_OUTPUT_DIRECTORY_PATH,
        "common",
        "test-helpers.test.ts"
      )
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

describe("getSharedTestDataDirectoryPath", () => {
  it("should get the correct shared test data directory", () => {
    const result = getSharedTestDataDirectoryPath();
    expect(result).toEqual(
      path.join(
        getProjectRoot(),
        TEST_OUTPUT_DIRECTORY_PATH,
        SHARED_TEST_DATA_DIRECTORY_PATH
      )
    );
  });
});
