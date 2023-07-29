import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  ResourceNotFoundError,
  RequestError,
} from "common/utils";
import {
  kFriendshipWithoutMessageParser,
  kFriendshipParser,
  parseDynamo,
  kIncomingFriendRequestParser,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";

const kFriendshipsNotFound = new RequestError(
  "FriendshipsNotFound",
  "No friendships could be found."
);

const kFriendRequestsNotFound = new RequestError(
  "FriendRequestsNotFound",
  "No friend requests could be found."
);

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo().connect();
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
    if (friendshipsRaw instanceof ResourceNotFoundError) {
      return kFriendshipsNotFound;
    } else if (friendRequests instanceof ResourceNotFoundError) {
      return kFriendRequestsNotFound;
    } else {
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
    }
  });
}
