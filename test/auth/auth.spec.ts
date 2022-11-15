/**
 * @jest-environment ./test/auth/auth.environment.ts
 */

import login from "./login";
import register from "./register";

describe("Auth Test Suite", () => {
  describe("Login", login);
  describe("Register", register);
});
