module.exports = {
  preset: "ts-jest",
  roots: ["<rootDir>/src/"],
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/src/$1",
  },
  testEnvironment: "node",
  verbose: true,
  setupFilesAfterEnv: ["<rootDir>/src/testing/setup-tests.ts"],
  // Coverage options
  collectCoverageFrom: [
    "src/cmd/**/*.ts",
    "src/internal/**/*.ts",
    "!src/internal/**/*.test.ts",
    "!src/cmd/**/*.test.ts",
  ],
  coverageDirectory: "test/coverage",
  openHandlesTimeout: 2 * 1000, // 2 seconds
};
