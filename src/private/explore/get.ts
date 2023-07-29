import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  RequestError,
  ResourceNotFoundError,
  kUserNotFound,
} from "common/utils";
import {
  kFriendshipWithoutMessageParser,
  kOutgoingFriendRequestParser,
  kUserExploreParser,
  kUserWithPartialInviteParser,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";

const kNoExploreUsersFound = new RequestError(
  "NoExploreUsersFound",
  "No users could be found."
);

const kNoFriendshipsFound = new RequestError(
  "NoFriendshipsFound",
  "No friendships could be found."
);

const kNoFriendRequestsFound = new RequestError(
  "NoFriendRequestsFound",
  "No friend requests could be found."
);

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo().connect();
    const user = await client.parsedQuery({
      pk: "USERS",
      sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
      parseShape: kUserWithPartialInviteParser,
    });
    if (user instanceof ResourceNotFoundError) {
      return kUserNotFound;
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
      if (othersAtGym instanceof ResourceNotFoundError) {
        return kNoExploreUsersFound;
      } else if (friends instanceof ResourceNotFoundError) {
        return kNoFriendshipsFound;
      } else if (friendRequests instanceof ResourceNotFoundError) {
        return kNoFriendRequestsFound;
      } else {
        const exploreUsers = await Promise.all(
          othersAtGym.filter((other) => {
            return (
              other.id !== user.id &&
              !friends.some(
                (friendship) => friendship.otherUser.id === other.id
              ) &&
              !friendRequests.some(
                (friendRequest) => friendRequest.receiver.id === other.id
              )
            );
          })
        );
        return new Success(exploreUsers);
      }
    }
  });
}
