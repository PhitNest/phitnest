import "mocha";
import request from "supertest";
import { expect } from "chai";
import Server from "../server";
import { produceAccessToken } from "./helpers";
import { testUser } from "./constants";

produceAccessToken().then((accessToken) => {
  describe("Request my user data", () => {
    it("should return my user data", () =>
      request(Server)
        .get("/user")
        .set("Authorization", `Bearer ${accessToken}`)
        .expect(200)
        .then((res: request.Response) => {
          expect(!!res.body.id).equal(true); // asserting not null
          expect(res.body.gymId).equal(testUser.gymId.toString());
          expect(res.body.cognitoId).equal(testUser.cognitoId);
          expect(res.body.firstName).equal(testUser.firstName);
          expect(res.body.lastName).equal(testUser.lastName);
        }));
  });
});
