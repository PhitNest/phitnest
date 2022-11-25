import {
  AuthenticationDetails,
  CognitoAccessToken,
  CognitoRefreshToken,
  CognitoUser,
  CognitoUserAttribute,
  CognitoUserPool,
  CognitoUserSession,
} from "amazon-cognito-identity-js";
import { l } from "../../common/logger";
import { IAuthRepository } from "../interfaces";
import { injectable } from "inversify";
import "cross-fetch/polyfill";

const userPool = new CognitoUserPool({
  UserPoolId: process.env.COGNITO_POOL_ID!,
  ClientId: process.env.COGNITO_APP_CLIENT_ID!,
});

@injectable()
export class CognitoAuthRepository implements IAuthRepository {
  signOut(cognitoId: string, allDevices: boolean) {
    const user = new CognitoUser({ Username: cognitoId, Pool: userPool });
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
    return new Promise<string | null>((resolve, reject) => {
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
            l.error(err);
            resolve(null);
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
          l.error(err);
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
          l.error(err);
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
          l.error(err);
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
          l.error(err);
          reject(err);
        },
      });
    });
  }

  registerUser(email: string, password: string) {
    return new Promise<string | null>((resolve, reject) => {
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
            l.error(err);
            resolve(null);
          } else {
            l.info(`Registered user with email: ${email}`);
            resolve(result.user.getUsername());
          }
        }
      );
    });
  }

  deleteUser(cognitoId: string) {
    const user = new CognitoUser({ Username: cognitoId, Pool: userPool });
    return new Promise<boolean>((resolve, reject) => {
      user.deleteUser((err) => {
        if (err) {
          l.error(`Could not delete user: ${cognitoId}`);
          l.error(err);
          resolve(false);
        } else {
          l.info(`Deleted user: ${cognitoId}`);
          resolve(true);
        }
      });
    });
  }

  refreshAccessToken(refreshToken: string, email: string) {
    const user = new CognitoUser({ Username: email, Pool: userPool });
    return new Promise<string | null>((resolve, reject) => {
      user.refreshSession(
        new CognitoRefreshToken({
          RefreshToken: refreshToken,
        }),
        (err: Error | null, session: CognitoUserSession) => {
          if (err) {
            l.error(`Could not refresh session for user with email: ${email}`);
            l.error(err);
            resolve(null);
          } else {
            l.info(`Refreshed session for user with email: ${email}`);
            resolve(session.getAccessToken().getJwtToken());
          }
        }
      );
    });
  }

  getCognitoId(accessToken: string) {
    const cognitoAccessToken = new CognitoAccessToken({
      AccessToken: accessToken,
    });
    const user = new CognitoUser({
      Username: cognitoAccessToken.payload.username,
      Pool: userPool,
    });
    return new Promise<string | null>((resolve, reject) => {
      user.getSession((err: Error | null, session: CognitoUserSession) => {
        if (session.isValid()) {
          const cognitoId = user.getUsername();
          l.info(`Authenticated user: ${cognitoId}`);
          resolve(cognitoId);
        } else {
          l.error(`Invalid access token: ${accessToken}`);
          l.error(err?.message ?? "Invalid session");
          resolve(null);
        }
      });
    });
  }
}
