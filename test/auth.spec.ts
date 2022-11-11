import "mocha";
import request from "supertest";
import Server from "../server";
import { testUser, testUserPassword } from "./constants";
import { produceAccessToken } from "./helpers";

produceAccessToken().then((accessToken) => {
  describe("Requesting an authenticated route without an access token", () => {
    it("should deny my request", () =>
      request(Server).get("/auth/authenticated").send().expect(401));
  });

  describe("Requesting an authenticated route with an access token", () => {
    it("should result in status code 200", () =>
      request(Server)
        .get("/auth/authenticated")
        .set("Authorization", `Bearer ${accessToken}`)
        .send()
        .expect(200));
  });

  describe("Register user that already exists", () => {
    it("should not allow registration", () =>
      request(Server)
        .post("/auth/register")
        .send({
          email: testUser.email,
          gymId: testUser.gymId,
          password: testUserPassword,
          firstName: testUser.firstName,
          lastName: testUser.lastName,
        })
        .expect(500));
  });
});
