import "mocha";
import request from "supertest";
import Server from "../server";
import { testUser } from "./constants";
import { produceAccessToken } from "./helpers";

produceAccessToken(testUser, (accessToken) => {
  describe("Request my gym data", () => {
    it("should reject my request without an access token", () =>
      request(Server).get("/gym").expect(401));

    it("should accept my request with an access token", () =>
      request(Server)
        .get("/gym")
        .set("Authorization", `Bearer ${accessToken}`)
        .expect(200));
  });
});
