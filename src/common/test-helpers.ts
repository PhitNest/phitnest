import * as path from "path";
import * as process from "process";

const TEST_OUTPUT_DIRECTORY_PATH = "test_data";
const SHARED_TEST_DATA_DIRECTORY_PATH = "shared_test_data";

export function getTestFilePath(...subPath: string[]) {
  let testPathString = expect.getState().testPath;
  expect(testPathString);
  testPathString = testPathString as string;
  const testOutputPath = path.join(process.cwd(), TEST_OUTPUT_DIRECTORY_PATH);
  const testPath = path.relative(
    path.join(process.cwd(), "src"),
    testPathString
  );
  return path.join(testOutputPath, testPath, ...subPath);
}

export function getSharedTestFilePath(...subPath: string[]): string {
  return path.join(
    process.cwd(),
    TEST_OUTPUT_DIRECTORY_PATH,
    SHARED_TEST_DATA_DIRECTORY_PATH,
    ...subPath
  );
}
