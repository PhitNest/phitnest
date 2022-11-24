import {
  AuthenticationDetails,
  CognitoAccessToken,
  CognitoRefreshToken,
  CognitoUser,
  CognitoUserAttribute,
  CognitoUserPool,
  CognitoUserSession,
} from "amazon-cognito-identity-js";
import { getEnv } from "../../common/env";
import { l } from "../../common/logger";
import { IAuthRepository } from "../interfaces";
import { injectable } from "inversify";
import "cross-fetch/polyfill";

const userPool = new CognitoUserPool({
  UserPoolId: getEnv().COGNITO_POOL_ID,
  ClientId: getEnv().COGNITO_APP_CLIENT_ID,
});

@injectable()
export class CognitoAuthRepository implements IAuthRepository {
  signOut(userId: string, allDevices: boolean) {
    const user = new CognitoUser({ Username: userId, Pool: userPool });
    return new Promise<void>((resolve, reject) => {
      if (allDevices) {
        user.globalSignOut({
          onSuccess: () => {
            l.info(`User ${user.getUsername()} signed out on all devices`);
            resolve();
          },
          onFailure: (err) => {
            l.error(`User ${user.getUsername()} could not be signed out`);
            reject(err);
          },
        });
      } else {
        /**
         * TODO: Add refresh token and access token to a blacklisted set in redis cache
         */
        user.signOut();
        l.info(`User ${user.getUsername()} signed out`);
        resolve();
      }
    });
  }

  login(email: string, password: string) {
    const user = new CognitoUser({
      Username: email,
      Pool: userPool,
    });
    return new Promise<string | undefined>((resolve, reject) => {
      user.authenticateUser(
        new AuthenticationDetails({
          Username: email,
          Password: password,
        }),
        {
          onSuccess: (session) => {
            l.info(`User authenticated with email: ${email}`);
            resolve(session.getAccessToken().getJwtToken());
          },
          onFailure: (err) => {
            l.error(`User could not be authenticated with email: ${email}`);
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
          l.error(`Could not resend confirmation code for user: ${email}`);
          reject(err);
        } else {
          l.info(`Resent confirmation code for user: ${email}`);
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
          l.error(`Could not confirm registration for user: ${email}`);
          reject(err);
        } else {
          l.info(`Confirmed registration for user: ${email}`);
          resolve();
        }
      });
    });
  }

  forgotPasswordSubmit(email: string, code: string, password: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<void>((resolve, reject) => {
      user.confirmPassword(code, password, {
        onSuccess: () => {
          l.info(`Changed password for user: ${email}`);
          resolve();
        },
        onFailure: (err) => {
          l.error(`Failed to change password for user: ${email}`);
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
          l.info(`Sent forgot password email to: ${email}`);
          resolve();
        },
        onFailure: (err) => {
          l.error(`Failed to send forgot password email to: ${email}`);
          reject(err);
        },
      });
    });
  }

  registerUser(email: string, password: string) {
    return new Promise<string | undefined>((resolve, reject) => {
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
            l.error(`Could not register user with email: ${email}`);
            reject(err);
          } else {
            l.info(`Registered user with email: ${email}`);
            resolve(result.user.getUsername());
          }
        }
      );
    });
  }

  deleteUser(userId: string) {
    const user = new CognitoUser({ Username: userId, Pool: userPool });
    return new Promise<boolean>((resolve, reject) => {
      user.deleteUser((err, result) => {
        if (err) {
          l.error(`Could not delete user: ${userId}`);
          reject(false);
        } else {
          l.info(`Deleted user: ${userId}`);
          resolve(true);
        }
      });
    });
  }

  refreshAccessToken(refreshToken: string, email: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<string | undefined>((resolve, reject) => {
      user.refreshSession(
        new CognitoRefreshToken({
          RefreshToken: refreshToken,
        }),
        (err: Error | null, session: CognitoUserSession) => {
          if (err) {
            l.error(`Could not refresh session for user with email: ${email}`);
            reject(err);
          } else {
            l.info(`Refreshed session for user with email: ${email}`);
            resolve(session.getAccessToken().getJwtToken());
          }
        }
      );
    });
  }

  getUserId(accessToken: string) {
    const cognitoAccessToken = new CognitoAccessToken({
      AccessToken: accessToken,
    });
    const user = new CognitoUser({
      Username: cognitoAccessToken.payload.username,
      Pool: userPool,
    });
    return new Promise<string | undefined>((resolve, reject) => {
      user.getSession((err: Error | null, session: CognitoUserSession) => {
        if (session.isValid()) {
          const userId = user.getUsername();
          l.info(`Authenticated user: ${userId}`);
          resolve(userId);
        } else {
          l.error(`Invalid access token: ${accessToken}`);
          reject(err?.message ?? "Invalid session");
        }
      });
    });
  }
}
