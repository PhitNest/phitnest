import { getTestOutputPath } from "test-helpers";
import * as fs from "fs";

beforeEach(() => {
  fs.rmSync(getTestOutputPath(), { recursive: true, force: true });
});
