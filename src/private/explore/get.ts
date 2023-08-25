import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  ResourceNotFoundError,
} from "common/utils";
import {
  kFriendshipWithoutMessageParser,
  kOutgoingFriendRequestParser,
  kUserExploreParser,
  kUserWithPartialInviteParser,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const user = await client.parsedQuery({
      pk: "USERS",
      sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
      parseShape: kUserWithPartialInviteParser,
    });
    if (user instanceof ResourceNotFoundError) {
      return user;
    } else {
      const [othersAtGym, friends, friendRequests] = await Promise.all([
        client.parsedQuery({
          pk: `GYM#${user.invite.gym.id}`,
          sk: { q: "USER#", op: "BEGINS_WITH" },
          parseShape: kUserExploreParser,
        }),
        client.parsedQuery({
          pk: `USER#${user.id}`,
          sk: { q: "FRIENDSHIP", op: "BEGINS_WITH" },
          parseShape: kFriendshipWithoutMessageParser,
        }),
        client.parsedQuery({
          pk: `USER#${user.id}`,
          sk: { q: "OUTGOING_REQUEST", op: "BEGINS_WITH" },
          parseShape: kOutgoingFriendRequestParser,
        }),
      ]);
      const exploreUsers = await Promise.all(
        othersAtGym.filter((other) => {
          const isMe = other.id === user.id;
          const isMyFriend = friends.some(
            (friendship) => friendship.otherUser.id === other.id
          );
          const sentRequest = friendRequests.some(
            (friendRequest) => friendRequest.receiver.id === other.id
          );
          return !isMe && !isMyFriend && !sentRequest;
        })
      );
      return new Success(exploreUsers);
    }
  });
}
