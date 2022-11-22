import {
  CognitoAccessToken,
  CognitoUser,
  CognitoUserPool,
  CognitoUserSession,
} from "amazon-cognito-identity-js";
import { env } from "../../../common/env";
import l from "../../../common/logger";
import { IAuthenticationRepository } from "../interfaces";
import Q from "q";

const userPool = new CognitoUserPool({
  UserPoolId: env.COGNITO_POOL_ID,
  ClientId: env.COGNITO_APP_CLIENT_ID,
});

export class CognitoAuthenticationRepository
  implements IAuthenticationRepository
{
  async authenticate(accessToken: string): Promise<string | undefined> {
    const cognitoAccessToken = new CognitoAccessToken({
      AccessToken: accessToken,
    });
    const user = new CognitoUser({
      Username: cognitoAccessToken.payload.username,
      Pool: userPool,
    });
    const defer = Q.defer<string | undefined>();
    user.getSession((err: Error | null, session: CognitoUserSession) => {
      let userId: string | undefined;
      if (session.isValid()) {
        userId = user.getUsername();
        l.info(`Authenticated user: ${userId}`);
      } else {
        l.error(`Invalid access token: ${accessToken}`);
      }
      defer.resolve(userId);
    });
    return await defer.promise;
  }
}
