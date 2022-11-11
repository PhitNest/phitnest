import "mocha";
import request from "supertest";
import { expect } from "chai";
import Server from "../server";
import { produceAccessToken } from "./helpers";
import { testUser } from "./constants";

produceAccessToken((accessToken) => {
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
