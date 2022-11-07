import { Request, Response, NextFunction } from "express";
import "cross-fetch/polyfill";
import {
  CognitoUserPool,
  CognitoRefreshToken,
  CognitoAccessToken,
  CognitoUser,
  CognitoUserAttribute,
  AuthenticationDetails,
  CognitoUserSession,
} from "amazon-cognito-identity-js";
import l from "../../common/logger";

const userPool = new CognitoUserPool({
  UserPoolId: process.env.COGNITO_POOL_ID,
  ClientId: process.env.COGNITO_APP_CLIENT_ID,
});

class CognitoMiddleware {
  authenticate(req: Request, res: Response, next: NextFunction) {
    try {
      const accessToken = new CognitoAccessToken({
        AccessToken: req.headers["authorization"].replace("Bearer ", ""),
      });
      const user = new CognitoUser({
        Username: accessToken.payload.username,
        Pool: userPool,
      });
      user.getSession((err: Error, session: CognitoUserSession) => {
        if (err) {
          l.error(`Invalid access token: ${accessToken.getJwtToken()}`);
          next(err);
        } else if (session.isValid()) {
          l.info(`Authenticated user: ${user.getUsername()}`);
          res.locals.cognitoSession = session;
          res.locals.cognitoId = user.getUsername();
          res.locals.cognitoUser = user;
          next();
        } else {
          l.error(`Invalid session: ${user.getUsername()}`);
          next({ message: "Expired session" });
        }
      });
    } catch (err) {
      next(err);
    }
  }

  refreshSession(req: Request, res: Response, next: NextFunction) {
    const user = new CognitoUser({ Username: req.body.email, Pool: userPool });
    user.refreshSession(
      new CognitoRefreshToken({
        RefreshToken: req.body.refreshToken,
      }),
      (err, session) => {
        if (err) {
          l.error(
            `Could not refresh session for user with email: ${req.body.email}`
          );
          next(err);
        } else {
          res.locals.cognitoSession = session;
          l.info(`Refreshed session for user with email: ${req.body.email}`);
          next();
        }
      }
    );
  }

  register(req: Request, res: Response, next: NextFunction) {
    userPool.signUp(
      req.body.email,
      req.body.password,
      [
        new CognitoUserAttribute({
          Name: "email",
          Value: req.body.email,
        }),
      ],
      null,
      function (err, result) {
        if (err) {
          l.error(`Could not register user with email: ${req.body.email}`);
          next(err);
        } else {
          l.info(
            `Registered user identity with username: ${result.user.getUsername()}`
          );
          res.locals.cognitoId = result.userSub;
          next();
        }
      }
    );
  }

  confirmRegister(req: Request, res: Response, next: NextFunction) {
    const user = new CognitoUser({ Username: req.body.email, Pool: userPool });
    user.confirmRegistration(req.body.code, true, (err) => {
      if (err) {
        l.error(
          `Could not confirm registration for user with email: ${req.body.email}`
        );
        next(err);
      } else {
        l.info(`Confirmed registration for user with email: ${req.body.email}`);
        next();
      }
    });
  }

  resendConfirmationCode(req: Request, res: Response, next: NextFunction) {
    new CognitoUser({
      Username: req.body.email,
      Pool: userPool,
    }).resendConfirmationCode((err) => {
      if (err) {
        l.error(
          `Could not resend confirmation code for user with email: ${req.body.email}`
        );
        next(err);
      } else {
        l.info(
          `Resent confirmation code for user with email: ${req.body.email}`
        );
        next();
      }
    });
  }

  login(req: Request, res: Response, next: NextFunction) {
    const user = new CognitoUser({
      Username: req.body.email,
      Pool: userPool,
    });
    user.authenticateUser(
      new AuthenticationDetails({
        Username: req.body.email,
        Password: req.body.password,
      }),
      {
        onSuccess: (session) => {
          res.locals.cognitoSession = session;
          res.locals.cognitoId = session.getAccessToken().payload.username;
          l.info(`User authenticated with email: ${req.body.email}`);
          next();
        },
        onFailure: (err) => {
          l.error(
            `User could not be authenticated with email: ${req.body.email}`
          );
          next(err);
        },
      }
    );
  }

  signOut(req: Request, res: Response, next: NextFunction) {
    const cognitoUser: CognitoUser = res.locals.cognitoUser;
    if (req.body.allDevices) {
      cognitoUser.globalSignOut({
        onSuccess: () => {
          l.info(`User ${cognitoUser.getUsername()} signed out on all devices`);
          next();
        },
        onFailure: (err) => {
          l.error(`User ${cognitoUser.getUsername()} could not be signed out`);
          next(err);
        },
      });
    } else {
      /**
       * TODO: Add refresh token and access token to a blacklisted set in redis cache
       */
      l.info(`User ${cognitoUser.getUsername()} signed out`);
      next();
    }
  }
}

export default new CognitoMiddleware();
