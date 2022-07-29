/**
 * @jest-environment ./tests/rest/auth/environment
 */

const testLogin = require("./login");

describe("Auth Test Suit", () => {
  describe("Login", testLogin);
});
