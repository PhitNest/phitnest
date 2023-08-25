import { dynamo, Success, getUserClaims, handleRequest } from "common/utils";
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
    const client = dynamo();
    const [friendshipsRaw, friendRequests] = await Promise.all([
      client.query({
        pk: `USER#${userClaims.sub}`,
        sk: { q: "FRIENDSHIP#", op: "BEGINS_WITH" },
      }),
      client.parsedQuery({
        pk: `USER#${userClaims.sub}`,
        sk: { q: "INCOMING_REQUEST#", op: "BEGINS_WITH" },
        parseShape: kIncomingFriendRequestParser,
      }),
    ]);
    const parsedFriendships = friendshipsRaw.map((friendship) => {
      if (friendship["recentMessage"]) {
        return parseDynamo(friendship, kFriendshipParser);
      } else {
        return parseDynamo(friendship, kFriendshipWithoutMessageParser);
      }
    });
    return new Success({
      friendships: parsedFriendships,
      friendRequests: friendRequests,
    });
  });
}
