module.exports = {
  clearMocks: true,
  coverageDirectory: 'coverage',
  coverageProvider: 'v8',
  globals: {
    app: null,
    io: null,
    redis: null,
  },
  verbose: true,
};
