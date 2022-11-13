import { expect } from "chai";
import "mocha";
import request from "supertest";
import Server from "../server";
import { testGyms, testUsers } from "./constants";
import { produceAccessToken } from "./helpers";
import { clear } from "./setup";

produceAccessToken(testUsers[0], (accessToken) => {
  describe("Gym Suite", () => {
    it("should reject my request without an access token", () =>
      request(Server).get("/gym").expect(401));
    it("should accept my request with an access token", () =>
      request(Server)
        .get("/gym")
        .set("Authorization", `Bearer ${accessToken}`)
        .expect(200));
    it("should find nearby gyms", () =>
      request(Server)
        .get("/gym/nearest")
        .query({ longitude: -80, latitude: 37, distance: 100 })
        .expect(200)
        .then((res: request.Response) => {
          expect(res.body.name).equal(testGyms[0].name);
          expect(JSON.stringify(res.body.address)).equal(
            JSON.stringify(testGyms[0].address)
          );
        }));
  });
});
