import * as path from "path";
import * as process from "process";

/** Path to the directory where test output files are stored */
const TEST_OUTPUT_DIRECTORY_PATH = "test_output";
/** Path to the directory where test data files are stored */
const TEST_DATA_DIRECTORY_PATH = "test_data";
/** Path to the directory where shared test data files are stored */
const SHARED_TEST_DATA_DIRECTORY_PATH = "shared_test_data";

/**
 * Constructs and returns the path to the output directory for a particular test.
 *
 * @param subPath - The sub directories or file within the test output directory.
 * @returns The absolute path string of the test output location.
 */
export function getTestOutputPath(...subPath: string[]) {
  // Fetching the current test path from the testing framework
  let testPathString = expect.getState().testPath;
  // Asserting that the testPathString is valid
  expect(testPathString);
  // Type assertion to string
  testPathString = testPathString as string;
  // Constructing the path to the test output directory
  const testOutputPath = path.join(process.cwd(), TEST_OUTPUT_DIRECTORY_PATH);
  // Calculating the relative path from the src directory to the test file
  const testPath = path.relative(
    path.join(process.cwd(), "src"),
    testPathString
  );
  // Returning the complete path to the test output location
  return path.join(testOutputPath, testPath, ...subPath);
}

/**
 * Constructs and returns the path to the data directory for a particular test.
 *
 * @param subPath - The sub directories or file within the test data directory.
 * @returns The absolute path string of the test data location.
 */
export function getTestDataPath(...subPath: string[]) {
  // Fetching the current test path from the testing framework
  let testPathString = expect.getState().testPath;
  // Asserting that the testPathString is valid
  expect(testPathString);
  // Type assertion to string
  testPathString = testPathString as string;
  // Constructing the path to the test data directory
  const testDataPath = path.join(process.cwd(), TEST_DATA_DIRECTORY_PATH);
  // Calculating the relative path from the src directory to the test file
  const testPath = path.relative(
    path.join(process.cwd(), "src"),
    testPathString
  );
  // Returning the complete path to the test data location
  return path.join(testDataPath, testPath, ...subPath);
}

/**
 * Constructs and returns the path to the shared data directory.
 *
 * @param subPath - The sub directories or file within the shared test data directory.
 * @returns The absolute path string of the shared test data location.
 */
export function getSharedTestDataPath(...subPath: string[]): string {
  // Returning the complete path to the shared test data location
  return path.join(
    process.cwd(),
    TEST_DATA_DIRECTORY_PATH,
    SHARED_TEST_DATA_DIRECTORY_PATH,
    ...subPath
  );
}
