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

      const identityClient = new CognitoIdentityClient({
        region: "us-east-1",
        credentials: fromCognitoIdentityPool({
          client: new CognitoIdentityClient({ region: "us-east-1" }),
          identityPoolId: environmentVars.USER_IDENTITY_POOL_ID,
          logins: {
            [environmentVars.USER_POOL_ID]: event.headers.Authorization,
          },
        }),
      });

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const res = (await identityClient.config.credentials()) as any;

      const client = dynamo().connect();

      client.put({
        pk: "IDENTITY_ID",
        sk: `ID#${userClaims.sub}`,
        data: {
          identityId: { S: res.identityId },
        },
      });

      return new Success();
    }
  });
}
