import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  ResourceNotFoundError,
  EnvironmentVars,
  RequestError,
  TransactionParams,
} from "common/utils";
import {
  User,
  friendshipWithoutMessageToDynamo,
  kUserExploreParser,
  kUserParser,
  kUserWithoutIdentityParser,
  userToDynamo,
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

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const user = await client.parsedQuery({
      pk: `USER#${userClaims.sub}`,
      sk: { q: "GYM#", op: "BEGINS_WITH" },
      limit: 1,
      parseShape: kUserParser,
    });
    if (user instanceof ResourceNotFoundError) {
      const newUser = await client.parsedQuery({
        pk: `USER#${userClaims.sub}`,
        sk: { q: `NEW#${userClaims.sub}`, op: "EQ" },
        parseShape: kUserWithoutIdentityParser,
      });
      if (newUser instanceof ResourceNotFoundError) {
        return newUser;
      }
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
      const userWithIdentity: User = {
        ...newUser,
        identityId: identity.identityId,
      };
      const transaction: TransactionParams = {
        deletes: [
          {
            pk: `USER#${userClaims.sub}`,
            sk: `NEW#${userClaims.sub}`,
          },
        ],
        puts: [
          {
            pk: `USER#${userClaims.sub}`,
            sk: `GYM#${userWithIdentity.invite.gymId}`,
            data: userToDynamo(userWithIdentity),
          },
        ],
      };
      if (userWithIdentity.invite.senderType === "user") {
        const friendshipId = uuid.v4();
        const friendshipCreatedAt = new Date();
        const sender = await client.parsedQuery({
          pk: `USER#${userWithIdentity.invite.senderId}`,
          sk: { q: `GYM#${userWithIdentity.invite.gymId}`, op: "EQ" },
          parseShape: kUserExploreParser,
        });
        if (sender instanceof ResourceNotFoundError) {
          return sender;
        }
        await client.writeTransaction({
          ...transaction,
          puts: [
            ...(transaction.puts ? transaction.puts : []),
            {
              pk: `USER#${userWithIdentity.invite.senderId}`,
              sk: `FRIENDSHIP#${userClaims.sub}`,
              data: friendshipWithoutMessageToDynamo({
                id: friendshipId,
                createdAt: friendshipCreatedAt,
                receiver: {
                  id: userWithIdentity.id,
                  firstName: userWithIdentity.firstName,
                  lastName: userWithIdentity.lastName,
                  identityId: userWithIdentity.identityId,
                  createdAt: userWithIdentity.createdAt,
                },
                sender: sender,
              }),
            },
          ],
        });
      } else {
        await client.writeTransaction(transaction);
      }
      return new Success(userWithIdentity);
    } else {
      return new Success(user);
    }
  });
}
