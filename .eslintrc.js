module.exports = {
  parserOptions: {
    project: "./tsconfig.json",
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
  rules: {
    // note you must disable the base rule as it can report incorrect errors
    "no-unused-vars": "off",
    "@typescript-eslint/no-unused-vars": ["error"],
  },
};
