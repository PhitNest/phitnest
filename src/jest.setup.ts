import { getTestOutputPath } from "test-helpers";
import { setupMocks } from "api/common/test-helpers";
import * as fs from "fs";
import { injectDynamo } from "api/common/utils";
import { DynamoMock } from "mock/mock-dynamo";

setupMocks();

beforeEach(() => {
  // Clear the test output directory before each test
  fs.rmSync(getTestOutputPath(), { recursive: true, force: true });
  injectDynamo(new DynamoMock());
});
