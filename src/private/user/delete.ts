import {
  dynamo,
  Success,
  handleRequest,
  getUserClaims,
  ResourceNotFoundError,
} from "common/utils";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  kFriendRequestParser,
  kFriendshipWithoutMessageParser,
  kInviteParser,
  kUserWithoutIdentityParser,
} from "common/entities";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const [
      user,
      receivedRequests,
      sentRequests,
      sentFriendships,
      receivedFriendships,
      invites,
    ] = await Promise.all([
      client.parsedQuery({
        pk: `USER#${userClaims.sub}`,
        sk: { q: "GYM#", op: "BEGINS_WITH" },
        limit: 1,
        parseShape: kUserWithoutIdentityParser,
      }),
      client.parsedQuery({
        pk: `FRIEND_REQUEST#${userClaims.sub}`,
        sk: { q: "USER#", op: "BEGINS_WITH" },
        table: "inverted",
        parseShape: kFriendRequestParser,
      }),
      client.parsedQuery({
        pk: `USER#${userClaims.sub}`,
        sk: { q: "FRIEND_REQUEST#", op: "BEGINS_WITH" },
        parseShape: kFriendRequestParser,
      }),
      client.parsedQuery({
        pk: `USER#${userClaims.sub}`,
        sk: { q: "FRIENDSHIP#", op: "BEGINS_WITH" },
        parseShape: kFriendshipWithoutMessageParser,
      }),
      client.parsedQuery({
        pk: `FRIENDSHIP#${userClaims.sub}`,
        sk: { q: "USER#", op: "BEGINS_WITH" },
        table: "inverted",
        parseShape: kFriendshipWithoutMessageParser,
      }),
      client.parsedQuery({
        pk: `USER#${userClaims.sub}`,
        sk: { q: "INVITE#", op: "BEGINS_WITH" },
        parseShape: kInviteParser,
      }),
    ]);
    if (user instanceof ResourceNotFoundError) {
      return user;
    } else {
      await Promise.all(
        [
          {
            pk: `USER#${userClaims.sub}`,
            sk: `GYM#${user.invite.gymId}`,
          },
          {
            pk: `USER#${userClaims.sub}`,
            sk: `NEW#${userClaims.sub}`,
          },
          ...receivedRequests.map((request) => ({
            pk: `USER#${request.sender.id}`,
            sk: `FRIEND_REQUEST#${userClaims.sub}`,
          })),
          ...sentRequests.map((request) => ({
            pk: `USER#${userClaims.sub}`,
            sk: `FRIEND_REQUEST#${request.receiver.id}`,
          })),
          ...sentFriendships.map((friendship) => ({
            pk: `USER#${userClaims.sub}`,
            sk: `FRIENDSHIP#${friendship.receiver.id}`,
          })),
          ...receivedFriendships.map((friendship) => ({
            pk: `USER#${friendship.sender.id}`,
            sk: `FRIENDSHIP#${userClaims.sub}`,
          })),
          ...invites.map((invite) => ({
            pk: `USER#${userClaims.sub}`,
            sk: `INVITE#${invite.receiverEmail}`,
          })),
        ].map((key) => client.delete(key))
      );
      return new Success();
    }
  });
}
