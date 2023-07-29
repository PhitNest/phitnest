import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  ResourceNotFoundError,
  EnvironmentVars,
  RequestError,
  kUserNotFound,
} from "common/utils";
import {
  UserInvitedByAdminWithoutIdentity,
  UserInvitedByUserWithoutIdentity,
  kUserInvitedByAdminParser,
  kUserInvitedByUserParser,
  kUserWithPartialInviteParser,
  parseDynamo,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { CognitoIdentityClient } from "@aws-sdk/client-cognito-identity";
import { fromCognitoIdentityPool } from "@aws-sdk/credential-provider-cognito-identity";

const kUnauthorized = new RequestError(
  "Unauthorized",
  "No Authorization header found on request."
);

const kIdentityAuthenticationFailed = new RequestError(
  "IdentityAuthenticationFailed",
  "Could not authenticate with identity pool."
);

const kFailedToWriteIdentity = new RequestError(
  "FailedToWriteIdentity",
  "Failed to write identity to database."
);

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo().connect();
    const userRaw = await client.query({
      pk: "USERS",
      sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
    });
    if (userRaw instanceof ResourceNotFoundError) {
      return kUserNotFound;
    } else {
      const userWithPartialInvite = parseDynamo(
        userRaw,
        kUserWithPartialInviteParser
      );
      let user:
        | UserInvitedByAdminWithoutIdentity
        | UserInvitedByUserWithoutIdentity;
      if (userWithPartialInvite.invite.type === "user") {
        user = parseDynamo(userRaw, kUserInvitedByUserParser);
      } else {
        user = parseDynamo(userRaw, kUserInvitedByAdminParser);
      }
      if (!userRaw.identityId) {
        if (!event.headers.Authorization) {
          return kUnauthorized;
        }

        const identityClient = new CognitoIdentityClient({
          region: EnvironmentVars.region(),
          credentials: fromCognitoIdentityPool({
            client: new CognitoIdentityClient({
              region: EnvironmentVars.region(),
            }),
            identityPoolId: EnvironmentVars.userIdentityPoolId(),
            logins: {
              [`cognito-idp.${EnvironmentVars.region()}.amazonaws.com/${EnvironmentVars.userPoolId()}`]:
                event.headers.Authorization,
            },
          }),
        });

        const identity =
          (await identityClient.config.credentials()) as unknown as {
            identityId: string;
          };

        if (!identity || !identity.identityId) {
          return kIdentityAuthenticationFailed;
        }

        const kUpdateExpressionVarMap = {
          ":identity": { S: identity.identityId },
        };

        await client.update<
          typeof user & { identityId: string },
          keyof typeof kUpdateExpressionVarMap
        >({
          pk: "USERS",
          sk: `USER#${user.id}`,
          expression: "SET identityId = :identity",
          varMap: kUpdateExpressionVarMap,
        });

        return new Success({ ...user, identityId: identity.identityId });
      } else if (!userRaw.identityId.S) {
        return kFailedToWriteIdentity;
      } else {
        return new Success({ ...user, identityId: userRaw.identityId.S });
      }
    }
  });
}
