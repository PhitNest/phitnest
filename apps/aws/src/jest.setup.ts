import { getTestOutputPath } from "jest-helpers/src/test-helpers";
import * as fs from "fs";

beforeEach(() => {
  // Clear the test output directory before each test
  fs.rmSync(getTestOutputPath(), { recursive: true, force: true });
});
