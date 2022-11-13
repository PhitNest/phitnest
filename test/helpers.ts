import "mocha";
import request from "supertest";
import Server from "../server";
import { testUserPassword } from "./constants";
import { IPublicUserModel, IUserModel } from "../server/src/models/user.model";
import Q from "q";
import { expect } from "chai";

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

export function comparePublicData(user: any, expected: IPublicUserModel) {
  expect(user.cognitoId).equals(expected.cognitoId);
  expect(user.gymId).equals(expected.gymId.toString());
  expect(user.firstName).equals(expected.firstName);
  expect(user.lastName).equals(expected.lastName);
}
