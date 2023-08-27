import { dynamo, Success, getUserClaims, handleRequest } from "common/utils";
import {
  kFriendshipWithoutMessageParser,
  kFriendshipParser,
  parseDynamo,
  kFriendRequestParser,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const [sentFriendshipsRaw, receivedFriendshipsRaw, receivedFriendRequests] =
      await Promise.all([
        client.query({
          pk: `USER#${userClaims.sub}`,
          sk: { q: "FRIENDSHIP#", op: "BEGINS_WITH" },
        }),
        client.query({
          pk: `FRIENDSHIP#${userClaims.sub}`,
          sk: { q: "USER#", op: "BEGINS_WITH" },
          table: "inverted",
        }),
        client.parsedQuery({
          pk: `FRIEND_REQUEST#${userClaims.sub}`,
          sk: { q: "USER#", op: "BEGINS_WITH" },
          table: "inverted",
          parseShape: kFriendRequestParser,
        }),
      ]);
    const parsedFriendships = [
      ...sentFriendshipsRaw,
      ...receivedFriendshipsRaw,
    ].map((friendship) => {
      if (friendship["recentMessage"]) {
        return parseDynamo(friendship, kFriendshipParser);
      } else {
        return parseDynamo(friendship, kFriendshipWithoutMessageParser);
      }
    });
    return new Success({
      friendships: parsedFriendships,
      friendRequests: receivedFriendRequests,
    });
  });
}
