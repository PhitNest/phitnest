import "cross-fetch/polyfill";
import {
  AuthenticationDetails,
  CognitoRefreshToken,
  CognitoUser,
  CognitoUserAttribute,
  CognitoUserPool,
  CognitoUserSession,
} from "amazon-cognito-identity-js";
//import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider";
import { IAuthRepository } from "../interfaces";
import { injectable } from "inversify";
import { IAuthEntity } from "../../entities";

const userPool = new CognitoUserPool({
  UserPoolId: process.env.COGNITO_POOL_ID ?? "",
  ClientId: process.env.COGNITO_APP_CLIENT_ID ?? "",
});

// const identityServiceProvider = new CognitoIdentityProvider({
//   region: process.env.COGNITO_REGION ?? "",
// });

@injectable()
export class CognitoAuthRepository implements IAuthRepository {
  signOut(cognitoId: string, allDevices: boolean) {
    const user = new CognitoUser({ Username: cognitoId, Pool: userPool });
    return new Promise<void>((resolve, reject) => {
      if (allDevices) {
        user.globalSignOut({
          onSuccess: () => {
            resolve();
          },
          onFailure: (err) => {
            reject(err);
          },
        });
      } else {
        /**
         * TODO: Add refresh token and access token to a blacklisted set in redis cache
         */
        user.signOut();
        resolve();
      }
    });
  }

  login(email: string, password: string) {
    const user = new CognitoUser({
      Username: email,
      Pool: userPool,
    });
    return new Promise<IAuthEntity>((resolve, reject) => {
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
            reject(err);
          },
        }
      );
    });
  }

  resendConfirmationCode(email: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<void>((resolve, reject) => {
      user.resendConfirmationCode((err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  }

  confirmRegister(email: string, code: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<void>((resolve, reject) => {
      user.confirmRegistration(code, true, (err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  }

  forgotPasswordSubmit(email: string, code: string, newPassword: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<void>((resolve, reject) => {
      user.confirmPassword(code, newPassword, {
        onSuccess: () => {
          resolve();
        },
        onFailure: (err) => {
          reject(err);
        },
      });
    });
  }

  forgotPassword(email: string) {
    const cognitoUser = new CognitoUser({
      Username: email,
      Pool: userPool,
    });
    return new Promise<void>((resolve, reject) => {
      cognitoUser.forgotPassword({
        onSuccess: () => {
          resolve();
        },
        onFailure: (err) => {
          reject(err);
        },
      });
    });
  }

  registerUser(email: string, password: string) {
    return new Promise<string>((resolve, reject) => {
      userPool.signUp(
        email,
        password,
        [
          new CognitoUserAttribute({
            Name: "email",
            Value: email,
          }),
        ],
        [],
        (err, result) => {
          if (err || !result) {
            reject(err ?? new Error("No result"));
          } else {
            resolve(result.userSub);
          }
        }
      );
    });
  }

  deleteUser(cognitoId: string) {
    const user = new CognitoUser({ Username: cognitoId, Pool: userPool });
    return new Promise<void>((resolve, reject) => {
      user.deleteUser((err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  }

  refreshSession(refreshToken: string, email: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<Omit<IAuthEntity, "refreshToken">>((resolve, reject) => {
      user.refreshSession(
        new CognitoRefreshToken({
          RefreshToken: refreshToken,
        }),
        (err: Error | null, session: CognitoUserSession) => {
          if (err) {
            reject(err);
          } else {
            resolve({
              accessToken: session.getAccessToken().getJwtToken(),
              idToken: session.getIdToken().getJwtToken(),
            });
          }
        }
      );
    });
  }

  async getCognitoId(accessToken: string) {
    // const rawUser = await identityServiceProvider.getUser({
    //   AccessToken: accessToken,
    // });
    // if (rawUser.UserAttributes) {
    //   return rawUser.UserAttributes.find((attr) => attr.Name === "sub")?.Value!;
    // } else {
    //   throw new Error("Invalid access token.");
    // }
    return "";
  }
}
