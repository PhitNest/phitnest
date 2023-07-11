import {
  dynamo,
  Success,
  handleRequest,
  getUserClaims,
  CognitoClaimsError,
  RequestError,
} from "common/utils";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  kFriendshipWithoutMessageParser,
  kIncomingFriendRequestParser,
  kInviteWithoutSenderParser,
  kOutgoingFriendRequestParser,
  kUserWithPartialInviteParser,
} from "common/entities";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    if (userClaims instanceof CognitoClaimsError) {
      return userClaims;
    } else {
      const client = dynamo().connect();
      const [user, incomingFriendRequests, friendRequests, friends, invites] =
        await Promise.all([
          client.parsedQuery({
            pk: "USERS",
            sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
            parseShape: kUserWithPartialInviteParser,
          }),
          client.parsedQuery({
            pk: `INCOMING_REQUEST#${userClaims.sub}`,
            sk: { q: "SENDER#", op: "BEGINS_WITH" },
            parseShape: kIncomingFriendRequestParser,
          }),
          client.parsedQuery({
            pk: `USER#${userClaims.sub}`,
            sk: { q: "FRIEND_REQUEST#", op: "BEGINS_WITH" },
            parseShape: kOutgoingFriendRequestParser,
          }),
          client.parsedQuery({
            pk: `USER#${userClaims.sub}`,
            sk: { q: "FRIENDSHIP#", op: "BEGINS_WITH" },
            parseShape: kFriendshipWithoutMessageParser,
          }),
          client.parsedQuery({
            pk: `INVITE#${userClaims.email}`,
            sk: { q: "RECEIVER#", op: "BEGINS_WITH" },
            parseShape: kInviteWithoutSenderParser,
          }),
        ]);
      if (user instanceof RequestError) {
        return user;
      } else if (incomingFriendRequests instanceof RequestError) {
        return incomingFriendRequests;
      } else if (friendRequests instanceof RequestError) {
        return friendRequests;
      } else if (friends instanceof RequestError) {
        return friends;
      } else if (invites instanceof RequestError) {
        return invites;
      } else {
        await Promise.all(
          [
            {
              pk: "USERS",
              sk: `USER#${userClaims.sub}`,
            },
            {
              pk: `GYM${user.invite.gym.id}`,
              sk: `USER#${userClaims.sub}`,
            },
            ...incomingFriendRequests.flatMap((request) => [
              {
                pk: `INCOMING_REQUEST#${userClaims.sub}`,
                sk: `SENDER#${request.sender.id}`,
              },
              {
                pk: `USER#${request.sender.id}`,
                sk: `FRIEND_REQUEST#${userClaims.sub}`,
              },
            ]),
            ...friendRequests.flatMap((request) => [
              {
                pk: `INCOMING_REQUEST#${request.receiver.id}`,
                sk: `SENDER#${userClaims.sub}`,
              },
              {
                pk: `USER#${userClaims.sub}`,
                sk: `FRIEND_REQUEST#${request.receiver.id}`,
              },
            ]),
            ...friends.flatMap((friendship) => [
              {
                pk: `USER#${friendship.otherUser.id}`,
                sk: `FRIENDSHIP#${userClaims.sub}`,
              },
              {
                pk: `USER#${userClaims.sub}`,
                sk: `FRIENDSHIP#${friendship.otherUser.id}`,
              },
            ]),
            ...invites.map((invite) => ({
              pk: `INVITE#${userClaims.sub}`,
              sk: `RECEIVER#${invite.receiverEmail}`,
            })),
          ].map((key) => client.delete(key))
        );
        return new Success();
      }
    }
  });
}
