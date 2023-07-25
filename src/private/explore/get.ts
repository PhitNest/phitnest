import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  CognitoClaimsError,
  RequestError,
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
    if (userClaims instanceof CognitoClaimsError) {
      return userClaims;
    } else {
      const client = dynamo().connect();
      const user = await client.parsedQuery({
        pk: "USERS",
        sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
        parseShape: kUserWithPartialInviteParser,
      });
      if (user instanceof RequestError) {
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
            sk: { q: "FRIEND_REQUEST", op: "BEGINS_WITH" },
            parseShape: kOutgoingFriendRequestParser,
          }),
        ]);
        if (othersAtGym instanceof RequestError) {
          return othersAtGym;
        } else if (friends instanceof RequestError) {
          return friends;
        } else if (friendRequests instanceof RequestError) {
          return friendRequests;
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
          const usersWithIdentity = await Promise.all(
            exploreUsers.map((user) =>
              client
                .parsedQuery({
                  pk: `IDENTITY_ID`,
                  sk: { q: `ID#${user.id}`, op: "EQ" },
                  parseShape: {
                    id: "S",
                  },
                })
                .then((identity) => ({
                  ...user,
                  identity: identity,
                }))
            )
          ).then((users) =>
            users.flatMap((user) => {
              if (user.identity instanceof RequestError) {
                return [];
              } else {
                return [
                  {
                    ...user,
                    identityId: user.identity.id,
                  },
                ];
              }
            })
          );
          return new Success(usersWithIdentity);
        }
      }
    }
  });
}
