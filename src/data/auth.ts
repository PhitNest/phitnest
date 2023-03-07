import { Failure } from "@/common/failure";
import { createUuid } from "@/common/uuid";
import {
  CognitoUserAttribute,
  CognitoUserPool,
} from "amazon-cognito-identity-js";

function userPool() {
  return new CognitoUserPool({
    UserPoolId: kCognitoCredentials.userPoolId,
    ClientId: kCognitoCredentials.clientId,
  });
}

export const kCognitoCredentials = {
  userPoolId: process.env.COGNITO_USER_POOL_ID ?? "sandbox",
  clientId: process.env.COGNITO_USER_POOL_APP_ID ?? "sandbox",
};

class Auth {
  async register(
    email: string,
    password: string,
    firstName: string,
    lastName: string
  ): Promise<string | Failure> {
    if (process.env.NODE_ENV === "development") {
      return createUuid();
    }
    return await new Promise<string | Failure>((resolve) => {
      userPool().signUp(
        email,
        password,
        [
          new CognitoUserAttribute({
            Name: "email",
            Value: email,
          }),
          new CognitoUserAttribute({
            Name: "given_name",
            Value: firstName,
          }),
          new CognitoUserAttribute({
            Name: "family_name",
            Value: lastName,
          }),
        ],
        [],
        (err, result) => {
          if (err != null) {
            resolve(new Failure(err.name, err.message));
          } else {
            resolve(result!.userSub);
          }
        }
      );
    });
  }
}

export default new Auth();
