import * as path from "path";
import * as process from "process";

export const TEST_OUTPUT_DIRECTORY_PATH = "test_data";
export const SHARED_TEST_DATA_DIRECTORY_PATH = "shared_test_data";

export function getTestDataDirectoryPath(): string {
  const testPathString = expect.getState().testPath;
  expect(testPathString);
  const testOutputPath = path.join(process.cwd(), TEST_OUTPUT_DIRECTORY_PATH);
  const testPath = path.relative(
    path.join(process.cwd(), "src"),
    testPathString!
  );
  return path.join(testOutputPath, testPath);
}

export function getTestFilePath(file: string) {
  return path.join(getTestDataDirectoryPath(), file);
}

export function getSharedTestDataDirectoryPath(): string {
  return path.join(
    process.cwd(),
    TEST_OUTPUT_DIRECTORY_PATH,
    SHARED_TEST_DATA_DIRECTORY_PATH
  );
}
