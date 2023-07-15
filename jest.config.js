module.exports = {
  testEnvironment: "node",
  testMatch: ["**/*.test.ts"],
  setupFilesAfterEnv: ["./src/jest.setup.ts"],
  transform: {
    "^.+\\.tsx?$": "ts-jest",
  },
  moduleDirectories: ["src", "node_modules"],
  testPathIgnorePatterns: ["test_data", "test_output"],
};
