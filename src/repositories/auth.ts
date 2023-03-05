import { Failure } from '@/common/failure';
import {
    AuthenticationDetails,
    CognitoUser,
    CognitoUserPool,
  } from "amazon-cognito-identity-js";

  const userPool = new CognitoUserPool({
    UserPoolId: process.env.COGNITO_USER_POOL_ID ?? "",
    ClientId: process.env.COGNITO_USER_POOL_APP_ID ?? "",
  });

  type LoginResponse = {
    accessToken: string;
    refreshToken: string;
    idToken: string;
  }

  export function login(email: string, password: string) {
    const user = new CognitoUser({
      Username: email,
      Pool: userPool,
    });
    return new Promise<LoginResponse | Failure>((resolve) => {
      user.authenticateUser(
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