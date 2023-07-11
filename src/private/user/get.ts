import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  CognitoClaimsError,
  ResourceNotFoundError,
  DynamoParseError,
} from "common/utils";
import {
  kUserInvitedByAdminParser,
  kUserInvitedByUserParser,
  kUserWithPartialInviteParser,
  parseDynamo,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    if (userClaims instanceof CognitoClaimsError) {
      return userClaims;
    } else {
      const client = dynamo().connect();
      const userRaw = await client.query({
        pk: "USERS",
        sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
      });
      if (userRaw instanceof ResourceNotFoundError) {
        return userRaw;
      } else {
        const userWithPartialInvite = parseDynamo(
          userRaw,
          kUserWithPartialInviteParser
        );
        if (userWithPartialInvite instanceof DynamoParseError) {
          return userWithPartialInvite;
        } else {
          if (userWithPartialInvite.invite.type === "user") {
            const user = parseDynamo(userRaw, kUserInvitedByUserParser);
            if (user instanceof DynamoParseError) {
              return user;
            } else {
              return new Success(user);
            }
          } else {
            const user = parseDynamo(userRaw, kUserInvitedByAdminParser);
            if (user instanceof DynamoParseError) {
              return user;
            } else {
              return new Success(user);
            }
          }
        }
      }
    }
  });
}
