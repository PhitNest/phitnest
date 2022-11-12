import "mocha";
import request from "supertest";
import Server from "../server";
import { testUserPassword } from "./constants";
import { IUserModel } from "../server/src/models/user.model";
import Q from "q";

export function produceAccessToken(
  user: IUserModel,
  callback: (accessToken: string) => void
) {
  const accessToken = Q.defer();
  describe("Login to test user", () => {
    it("should produce an access token", () =>
      request(Server)
        .post("/auth/login")
        .send({
          email: user.email,
          password: testUserPassword,
        })
        .expect(200)
        .then((res: request.Response) => {
          accessToken.resolve(res.body.accessToken);
        }));
  });
  accessToken.promise.then(callback);
}
