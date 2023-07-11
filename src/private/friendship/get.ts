import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  CognitoClaimsError,
  ResourceNotFoundError,
  RequestError,
  DynamoParseError,
} from "common/utils";
import {
  kFriendshipWithoutMessageParser,
  kFriendshipParser,
  parseDynamo,
  kIncomingFriendRequestParser,
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
      const [friendshipsRaw, friendRequests] = await Promise.all([
        client.query({
          pk: `USER#${userClaims.sub}`,
          sk: { q: "FRIENDSHIP#", op: "BEGINS_WITH" },
        }),
        client.parsedQuery({
          pk: `INCOMING_REQUEST#${userClaims.sub}`,
          sk: { q: "SENDER#", op: "BEGINS_WITH" },
          parseShape: kIncomingFriendRequestParser,
        }),
      ]);
      if (friendshipsRaw instanceof ResourceNotFoundError) {
        return friendshipsRaw;
      } else if (friendRequests instanceof RequestError) {
        return friendRequests;
      } else {
        const parsedFriendships = friendshipsRaw.map((friendship) => {
          if (friendship["recentMessage"]) {
            return parseDynamo(friendship, kFriendshipParser);
          } else {
            return parseDynamo(friendship, kFriendshipWithoutMessageParser);
          }
        });
        const failedParse = parsedFriendships.find(
          (friendship) => friendship instanceof DynamoParseError
        );
        if (failedParse) {
          return failedParse as DynamoParseError;
        } else {
          return new Success({
            friendships: parsedFriendships,
            friendRequests: friendRequests,
          });
        }
      }
    }
  });
}
