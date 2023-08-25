import {
  dynamo,
  Success,
  handleRequest,
  getUserClaims,
  ResourceNotFoundError,
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
    const client = dynamo();
    const [user, incomingFriendRequests, friendRequests, friends, invites] =
      await Promise.all([
        client.parsedQuery({
          pk: "USERS",
          sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
          parseShape: kUserWithPartialInviteParser,
        }),
        client.parsedQuery({
          pk: `USER#${userClaims.sub}`,
          sk: { q: "INCOMING_REQUEST#", op: "BEGINS_WITH" },
          parseShape: kIncomingFriendRequestParser,
        }),
        client.parsedQuery({
          pk: `USER#${userClaims.sub}`,
          sk: { q: "OUTGOING_REQUEST#", op: "BEGINS_WITH" },
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
    if (user instanceof ResourceNotFoundError) {
      return user;
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
  });
}
