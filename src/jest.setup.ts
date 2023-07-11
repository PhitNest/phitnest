import { getTestOutputPath } from "test-helpers";
import { setupMocks } from "common/test-helpers";
import { injectDynamo } from "common/utils";
import { DynamoMock } from "mock/mock-dynamo";
import * as fs from "fs";

setupMocks();

beforeEach(() => {
  // Clear the test output directory before each test
  fs.rmSync(getTestOutputPath(), { recursive: true, force: true });
  injectDynamo(new DynamoMock());
});
