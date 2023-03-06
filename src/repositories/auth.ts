import { Failure } from "@/common/failure";
import { createUuid } from "@/common/uuid";
import {
  AuthenticationDetails,
  CognitoUser,
  CognitoUserAttribute,
  CognitoUserPool,
} from "amazon-cognito-identity-js";

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  idToken: string;
}

export const kMockLoginResponse = {
  accessToken: "mockAccessToken",
  refreshToken: "mockRefreshToken",
  idToken: "mockIdToken",
} as const;

function userPool() {
  return new CognitoUserPool({
    UserPoolId: process.env.COGNITO_USER_POOL_ID ?? "",
    ClientId: process.env.COGNITO_USER_POOL_APP_ID ?? "",
  });
}

export async function register(
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
        if (err) {
          resolve(new Failure(err.name, err.message));
        } else {
          resolve(result!.userSub);
        }
      }
    );
  });
}

export async function login(
  email: string,
  password: string
): Promise<LoginResponse | Failure> {
  if (process.env.NODE_ENV === "development") {
    return kMockLoginResponse;
  }
  return await new Promise<LoginResponse | Failure>((resolve) => {
    new CognitoUser({
      Username: email,
      Pool: userPool(),
    }).authenticateUser(
      new AuthenticationDetails({
        Username: email,
        Password: password,
      }),
      {
        onSuccess: (session) => {
          resolve({
            accessToken: session.getAccessToken().getJwtToken(),
            refreshToken: session.getRefreshToken().getToken(),
            idToken: session.getIdToken().getJwtToken(),
          });
        },
        onFailure: (err) => {
          resolve(new Failure(err.name, err.message));
        },
      }
    );
  });
}
