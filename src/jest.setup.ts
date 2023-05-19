import { getTestOutputPath } from "test-helpers";
import {
  clearDynamoMock,
  setupDynamoMock,
  setupMocks,
} from "api/common/test-helpers";
import * as fs from "fs";

setupMocks();

beforeEach(() => {
  // Clear the test output directory before each test
  fs.rmSync(getTestOutputPath(), { recursive: true, force: true });
  setupDynamoMock();
});

afterEach(() => {
  clearDynamoMock();
});
