import "mocha";
import request from "supertest";
import Server from "../server";
import { testUser, testUserPassword } from "./constants";
import Q from "q";

export function produceAccessToken(callback: (accessToken: string) => void) {
  const accessToken = Q.defer();
  describe("Login to test user", () => {
    it("should produce an access token", () =>
      request(Server)
        .post("/auth/login")
        .send({
          email: testUser.email,
          password: testUserPassword,
        })
        .expect(200)
        .then((res: request.Response) => {
          accessToken.resolve(res.body.accessToken);
        }));
  });
  accessToken.promise.then(callback);
}
