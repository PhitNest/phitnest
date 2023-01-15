import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider";
import {
  AuthenticationDetails,
  CognitoRefreshToken,
  CognitoUser,
  CognitoUserAttribute,
  CognitoUserPool,
  CognitoUserSession,
} from "amazon-cognito-identity-js";
import { kUserNotFound } from "../../../common/failures";
import { Failure } from "../../../common/types";
import { IRefreshSessionEntity, IAuthEntity } from "../../../domain/entities";
import { IAuthDatabase } from "../interfaces";

const userPool = new CognitoUserPool({
  UserPoolId: process.env.COGNITO_POOL_ID ?? "",
  ClientId: process.env.COGNITO_APP_CLIENT_ID ?? "",
});

const identityServiceProvider = new CognitoIdentityProvider({
  region: process.env.COGNITO_REGION ?? "",
});

export class CognitoAuthDatabase implements IAuthDatabase {
  async getCognitoId(accessToken: string) {
    const rawUser = await identityServiceProvider.getUser({
      AccessToken: accessToken,
    });
    if (rawUser.UserAttributes) {
      return rawUser.UserAttributes.find((attr) => attr.Name === "sub")?.Value!;
    } else {
      return kUserNotFound;
    }
  }

  refreshSession(refreshToken: string, email: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<IRefreshSessionEntity | Failure>((resolve) => {
      user.refreshSession(
        new CognitoRefreshToken({
          RefreshToken: refreshToken,
        }),
        (err: Error | null, session: CognitoUserSession) => {
          if (err) {
            resolve(new Failure(err!.name, err!.message));
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

  deleteUser(cognitoId: string) {
    const user = new CognitoUser({ Username: cognitoId, Pool: userPool });
    return new Promise<void | Failure>((resolve) => {
      user.deleteUser((err) => {
        if (err) {
          resolve(new Failure(err.name, err.message));
        } else {
          resolve();
        }
      });
    });
  }

  registerUser(email: string, password: string) {
    return new Promise<string | Failure>((resolve) => {
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
          if (err) {
            resolve(new Failure(err.name, err.message));
          } else {
            resolve(result!.userSub);
          }
        }
      );
    });
  }

  async signOut(accessToken: string) {
    await new Promise<void | Failure>((resolve) => {
      identityServiceProvider.globalSignOut(
        {
          AccessToken: accessToken,
        },
        {},
        (err, data) => {
          if (err) {
            resolve(new Failure(err.name, err.message));
          } else {
            resolve();
          }
        }
      );
    });
  }

  forgotPassword(email: string) {
    const cognitoUser = new CognitoUser({
      Username: email,
      Pool: userPool,
    });
    return new Promise<void | Failure>((resolve) => {
      cognitoUser.forgotPassword({
        onSuccess: () => {
          resolve();
        },
        onFailure: (err) => {
          resolve(new Failure(err.name, err.message));
        },
      });
    });
  }

  forgotPasswordSubmit(email: string, code: string, newPassword: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<void | Failure>((resolve) => {
      user.confirmPassword(code, newPassword, {
        onSuccess: () => {
          resolve();
        },
        onFailure: (err) => {
          resolve(new Failure(err.name, err.message));
        },
      });
    });
  }

  confirmRegister(email: string, code: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<void | Failure>((resolve) => {
      user.confirmRegistration(code, true, (err) => {
        if (err) {
          resolve(new Failure(err.name, err.message));
        } else {
          resolve();
        }
      });
    });
  }

  login(email: string, password: string) {
    const user = new CognitoUser({
      Username: email,
      Pool: userPool,
    });
    return new Promise<IAuthEntity | Failure>((resolve) => {
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

  resendConfirmationCode(email: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<void | Failure>((resolve) => {
      user.resendConfirmationCode((err) => {
        if (err) {
          resolve(new Failure(err.name, err.message));
        } else {
          resolve();
        }
      });
    });
  }
}
