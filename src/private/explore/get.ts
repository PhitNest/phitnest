import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  ResourceNotFoundError,
} from "common/utils";
import {
  kFriendRequestParser,
  kFriendshipWithoutMessageParser,
  kUserExploreParser,
  kUserWithoutIdentityParser,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";

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
      parseShape: kUserWithoutIdentityParser,
    });
    if (user instanceof ResourceNotFoundError) {
      return user;
    } else {
      const [
        othersAtGym,
        sentFriendships,
        receivedFriendships,
        sentFriendRequests,
      ] = await Promise.all([
        client.parsedQuery({
          pk: `GYM#${user.invite.gymId}`,
          sk: { q: "USER#", op: "BEGINS_WITH" },
          table: "inverted",
          parseShape: kUserExploreParser,
        }),
        client.parsedQuery({
          pk: `USER#${user.id}`,
          sk: { q: "FRIENDSHIP#", op: "BEGINS_WITH" },
          parseShape: kFriendshipWithoutMessageParser,
        }),
        client.parsedQuery({
          pk: `FRIENDSHIP#${user.id}`,
          sk: { q: "USER#", op: "BEGINS_WITH" },
          table: "inverted",
          parseShape: kFriendshipWithoutMessageParser,
        }),
        client.parsedQuery({
          pk: `USER#${user.id}`,
          sk: { q: "FRIEND_REQUEST#", op: "BEGINS_WITH" },
          parseShape: kFriendRequestParser,
        }),
      ]);
      const exploreUsers = await Promise.all(
        othersAtGym.filter((other) => {
          const isMe = other.id === user.id;
          const sentRequest = sentFriendRequests.some(
            (friendship) => friendship.receiver.id === other.id
          );
          const sentFriendship = sentFriendships.some(
            (friendship) => friendship.receiver.id === other.id
          );
          const receivedFriendship = receivedFriendships.some(
            (friendship) => friendship.sender.id === other.id
          );
          return (
            !isMe && !sentFriendship && !receivedFriendship && !sentRequest
          );
        })
      );
      return new Success(exploreUsers);
    }
  });
}
