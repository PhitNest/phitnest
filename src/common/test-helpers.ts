import * as path from "path";
import * as process from "process";

const TEST_OUTPUT_DIRECTORY_PATH = "test_data";

export function getTestDataDirectoryPath(): string {
  const testPathString = expect.getState().testPath;
  expect(testPathString);
  const testOutputPath = path.join(process.cwd(), TEST_OUTPUT_DIRECTORY_PATH);
  let testPath = path.relative(
    path.join(process.cwd(), "src"),
    testPathString!
  );
  return path.join(testOutputPath, testPath);
}

export function getTestFilePath(file: string) {
  return path.join(getTestDataDirectoryPath(), file);
}
