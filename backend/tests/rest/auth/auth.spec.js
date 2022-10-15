/**
 * @jest-environment ./tests/environment
 */

const testLogin = require("./login");
const testRegister = require("./register");

describe("Auth Test Suite", () => {
  describe("Login", testLogin);
  describe("Register", testRegister);
});
