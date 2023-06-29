import {
  dynamo,
  validateRequest,
  Success,
  getUserClaims,
} from "api/common/utils";
import {
  kFriendRequestDynamo,
  kFriendshipWithoutMessageDynamo,
  kUserExploreDynamo,
  kUserWithPartialInviteDynamo,
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
      const user = await client.parsedQuery({
        pk: "USERS",
        sk: { q: `USER#${data.userId}`, op: "EQ" },
        parseShape: kUserWithPartialInviteDynamo,
      });
      const [othersAtGym, friends, friendRequests] = await Promise.all([
        client.parsedQuery({
          pk: `GYM#${user.invite.gym.id}`,
          sk: { q: "USER#", op: "BEGINS_WITH" },
          parseShape: kUserExploreDynamo,
        }),
        client.parsedQuery({
          pk: `USER#${user.accountDetails.id}`,
          sk: { q: "FRIENDSHIP", op: "BEGINS_WITH" },
          parseShape: kFriendshipWithoutMessageDynamo,
        }),
        client.parsedQuery({
          pk: `USER#${user.accountDetails.id}`,
          sk: { q: "FRIEND_REQUEST", op: "BEGINS_WITH" },
          parseShape: kFriendRequestDynamo,
        }),
      ]);
      return new Success(
        othersAtGym.filter((other) => {
          return (
            !friends.some((friendship) =>
              friendship.users.some(
                (friend) => friend.accountDetails.id === other.accountDetails.id
              )
            ) &&
            !friendRequests.some((friendRequest) =>
              friendRequest.users.some(
                (request) =>
                  request.accountDetails.id === other.accountDetails.id
              )
            )
          );
        })
      );
    },
  });
}
