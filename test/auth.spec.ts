import "mocha";
import request from "supertest";
import Server from "../server";
import { testUsers, testUserPassword } from "./constants";
import { produceAccessToken } from "./helpers";
import { clear } from "./setup";

const testUser = testUsers[0];

produceAccessToken(testUser, (accessToken) => {
  describe("Auth Suite", () => {
    it("should ", () =>
      request(Server).get("/auth/authenticated").send().expect(401));

    it("should accept my request with an access token", () =>
      request(Server)
        .get("/auth/authenticated")
        .set("Authorization", `Bearer ${accessToken}`)
        .expect(200));

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
