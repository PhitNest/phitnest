import {
  getSharedTestDataPath,
  getTestDataPath,
  getTestOutputPath,
} from "./test-helpers";
import * as fs from "fs";

describe("getTestDataPath", () => {
  it("should get the file in test_data", () => {
    const test = fs.readFileSync(getTestDataPath("test.txt"));
    expect(test.toString()).toEqual("FooBar");
  });
});

describe("getTestOutputPath", () => {
  it("should write the file in test_output", () => {
    fs.writeFileSync(getTestOutputPath("test.txt"), "BarFoo");
    const test = fs.readFileSync(getTestOutputPath("test.txt"));
    expect(test.toString()).toEqual("BarFoo");
  });
});

describe("getSharedTestDataPath", () => {
  it("should get the file in shared_test_data", () => {
    const test = fs.readFileSync(getSharedTestDataPath("test.txt"));
    expect(test.toString()).toEqual("FooBar");
  });
});
