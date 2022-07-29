module.exports = {
  clearMocks: true,
  collectCoverage: true,
  coverageDirectory: "coverage",
  coverageProvider: "v8",
  globals: {
    app: null,
    redis: null,
    data: {},
  },
  verbose: true,
};
