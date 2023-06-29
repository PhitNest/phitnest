import {
  dynamo,
  validateRequest,
  Success,
  getUserClaims,
} from "api/common/utils";
import {
  kUserWithPartialInviteDynamo,
  kFriendshipWithoutMessageDynamo,
  kFriendRequestDynamo,
} from "api/common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  userId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: { userId: getUserClaims(event)?.sub },
    validator: validator,
    controller: async (data) => {
      const client = dynamo().connect();
      const [user, incomingFriendRequests, friendRequests, friends] =
        await Promise.all([
          client.parsedQuery({
            pk: "USERS",
            sk: { q: `USER#${data.userId}`, op: "EQ" },
            parseShape: kUserWithPartialInviteDynamo,
          }),
          client.parsedQuery({
            pk: `INCOMING_REQUEST#${data.userId}`,
            sk: { q: "SENDER#", op: "BEGINS_WITH" },
            parseShape: kFriendRequestDynamo,
          }),
          client.parsedQuery({
            pk: `USER#${data.userId}`,
            sk: { q: "FRIEND_REQUEST#", op: "BEGINS_WITH" },
            parseShape: kFriendshipWithoutMessageDynamo,
          }),
          client.parsedQuery({
            pk: `USER#${data.userId}`,
            sk: { q: "FRIENDSHIP#", op: "BEGINS_WITH" },
            parseShape: kFriendshipWithoutMessageDynamo,
          }),
        ]);
      await client.writeTransaction({
        puts: [],
        updates: [],
        deletes: [
          {
            pk: "USERS",
            sk: `USER#${data.userId}`,
          },
          {
            pk: `GYM${user.invite.gym.id}`,
            sk: `USER#${data.userId}`,
          },
          ...incomingFriendRequests.map((request) => ({
            pk: `INCOMING_REQUEST#${data.userId}`,
            sk: `SENDER#${
              request.users.filter(
                (sender) => sender.accountDetails.id != data.userId
              )[0].accountDetails.id
            }`,
          })),
          ...incomingFriendRequests.map((request) => ({
            pk: `USER#${
              request.users.filter(
                (sender) => sender.accountDetails.id != data.userId
              )[0].accountDetails.id
            }`,
            sk: `FRIEND_REQUEST#${data.userId}`,
          })),
          ...friendRequests.map((request) => ({
            pk: `INCOMING_REQUEST#${
              request.users.filter(
                (sender) => sender.accountDetails.id != data.userId
              )[0].accountDetails.id
            }`,
            sk: `SENDER#${data.userId}`,
          })),
          ...friendRequests.map((request) => ({
            pk: `USER#${data.userId}`,
            sk: `FRIEND_REQUEST#${
              request.users.filter(
                (sender) => sender.accountDetails.id != data.userId
              )[0].accountDetails.id
            }`,
          })),
          ...friends.map((friendship) => ({
            pk: `USER#${
              friendship.users.filter(
                (friend) => friend.accountDetails.id != data.userId
              )[0].accountDetails.id
            }`,
            sk: `FRIENDSHIP#${data.userId}`,
          })),
          ...friends.map((friendship) => ({
            pk: `USER#${data.userId}`,
            sk: `FRIENDSHIP#${
              friendship.users.filter(
                (friend) => friend.accountDetails.id != data.userId
              )[0].accountDetails.id
            }`,
          })),
        ],
      });
      return new Success();
    },
  });
}
