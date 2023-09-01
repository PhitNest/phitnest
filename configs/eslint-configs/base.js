module.exports = {
  parserOptions: {
    sourceType: "module",
    ecmaVersion: "latest",
  },
  plugins: [],
  extends: [
    "plugin:prettier/recommended",
    "plugin:@typescript-eslint/recommended",
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: ["test_data/**/*", "test_output/**/*", "node_modules/**/*"],
  rules: {
    // note you must disable the base rule as it can report incorrect errors
    "no-unused-vars": "off",
    "@typescript-eslint/no-unused-vars": ["error"],
    "@typescript-eslint/no-explicit-any": ["error"],
    "@typescript-eslint/no-non-null-assertion": ["error"],
    "prettier/prettier": ["error", { endOfLine: "auto" }],
  },
};
