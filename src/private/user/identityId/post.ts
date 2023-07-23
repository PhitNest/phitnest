import { CognitoIdentityClient } from "@aws-sdk/client-cognito-identity";
import { fromCognitoIdentityPool } from "@aws-sdk/credential-provider-cognito-identity";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  CognitoClaimsError,
  RequestError,
  Success,
  dynamo,
  environmentVars,
  getUserClaims,
  handleRequest,
} from "common/utils";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    if (userClaims instanceof CognitoClaimsError) {
      return userClaims;
    } else {
      if (!environmentVars.USER_POOL_ID) {
        return new RequestError(
          "INVALID_BACKEND_CONFIG",
          "Unable to find user pool id"
        );
      }
      if (!environmentVars.USER_IDENTITY_POOL_ID) {
        return new RequestError(
          "INVALID_BACKEND_CONFIG",
          "Unable to find user identity pool id"
        );
      }
      if (!event.headers.Authorization) {
        return new RequestError(
          "MISSING_AUTHORIZATION_HEADER",
          "Unable to find authorization header"
        );
      }

      const credentials = await fromCognitoIdentityPool({
        client: new CognitoIdentityClient({}),
        identityPoolId: environmentVars.USER_IDENTITY_POOL_ID,
        logins: {
          [environmentVars.USER_POOL_ID]: event.headers.Authorization,
        },
      })();

      const client = dynamo().connect();

      client.put({
        pk: "IDENTITY_ID",
        sk: `ID#${userClaims.sub}`,
        data: {
          identityId: { S: credentials.identityId },
        },
      });

      return new Success();
    }
  });
}
