import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  ResourceNotFoundError,
  EnvironmentVars,
  RequestError,
  UpdateParams,
} from "common/utils";
import {
  UserInvitedByAdmin,
  UserInvitedByUser,
  friendshipWithoutMessageToDynamo,
  kUserInvitedByAdminParser,
  kUserInvitedByUserParser,
  kUserWithPartialInviteParser,
  parseDynamo,
  userExploreToDynamo,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { CognitoIdentityClient } from "@aws-sdk/client-cognito-identity";
import { fromCognitoIdentityPool } from "@aws-sdk/credential-provider-cognito-identity";
import * as uuid from "uuid";

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
    const client = dynamo();
    const userRaw = await client.query({
      pk: "USERS",
      sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
    });
    if (userRaw instanceof ResourceNotFoundError) {
      return userRaw;
    } else {
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

        const userRawWithIdentity = {
          ...userRaw,
          identityId: { S: identity.identityId },
        };
        const userWithPartialInvite = parseDynamo(
          userRawWithIdentity,
          kUserWithPartialInviteParser
        );
        let user: UserInvitedByAdmin | UserInvitedByUser;
        if (userWithPartialInvite.invite.type === "user") {
          user = parseDynamo(userRaw, kUserInvitedByUserParser);
        } else {
          user = parseDynamo(userRaw, kUserInvitedByAdminParser);
        }

        const updateIdentity: UpdateParams = {
          pk: "USERS",
          sk: `USER#${user.id}`,
          expression: "SET identityId = :identity",
          varMap: kUpdateExpressionVarMap,
        };
        if (user.invite.type === "user") {
          const friendshipId = uuid.v4();
          const friendshipCreatedAt = new Date();
          await client.writeTransaction({
            updates: [updateIdentity],
            puts: [
              {
                pk: `USER#${user.invite.inviter.id}`,
                sk: `FRIENDSHIP#${user.id}`,
                data: friendshipWithoutMessageToDynamo({
                  id: friendshipId,
                  createdAt: friendshipCreatedAt,
                  otherUser: userWithPartialInvite,
                }),
              },
              {
                pk: `USER#${user.id}`,
                sk: `FRIENDSHIP#${user.invite.inviter.id}`,
                data: friendshipWithoutMessageToDynamo({
                  id: friendshipId,
                  createdAt: friendshipCreatedAt,
                  otherUser: user.invite.inviter,
                }),
              },
              {
                pk: `GYM#${user.invite.gym.id}`,
                sk: `USER#${user.id}`,
                data: userExploreToDynamo(userWithPartialInvite),
              },
            ],
          });
        } else {
          await client.update(updateIdentity);
        }
        return new Success(userWithPartialInvite);
      } else if (!userRaw.identityId.S) {
        return kFailedToWriteIdentity;
      } else {
        const userWithPartialInvite = parseDynamo(
          userRaw,
          kUserWithPartialInviteParser
        );
        let user: UserInvitedByAdmin | UserInvitedByUser;
        if (userWithPartialInvite.invite.type === "user") {
          user = parseDynamo(userRaw, kUserInvitedByUserParser);
        } else {
          user = parseDynamo(userRaw, kUserInvitedByAdminParser);
        }
        return new Success({ ...user, identityId: userRaw.identityId.S });
      }
    }
  });
}
