module.exports = {
  preset: "ts-jest",
  roots: ["<rootDir>/src/"],
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/src/$1",
  },
  testEnvironment: "node",
  verbose: true,
  setupFilesAfterEnv: ["<rootDir>/src/setup-tests.ts"],
  // Coverage options
  collectCoverageFrom: [
    "src/cmd/**/*.ts",
    "src/internal/**/*.ts",
    "!src/internal/**/*.test.ts",
    "!src/cmd/**/*.test.ts",
  ],
  coverageDirectory: "test/coverage",
};
