import "mocha";
import request from "supertest";
import Server from "../server";
import { testUser, testUserPassword } from "./constants";

describe("Register user that already exists", () => {
  it("should not allow registration", () =>
    request(Server)
      .post("/auth/register")
      .send({
        email: testUser.email,
        password: testUserPassword,
        firstName: testUser.firstName,
        lastName: testUser.lastName,
      })
      .expect(500));
});
