import {
  dynamo,
  validateRequest,
  Success,
  getUserClaims,
} from "api/common/utils";
import {
  kFriendshipWithoutMessageDynamo,
  kFriendshipDynamo,
  parseDynamo,
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
      const friendshipsRaw = await client.query({
        pk: `USER#${data.userId}`,
        sk: { q: "FRIENDSHIP#", op: "BEGINS_WITH" },
      });
      return new Success(
        friendshipsRaw.map((friendship) => {
          if (friendship["recentMessage"]) {
            return parseDynamo(friendship, kFriendshipDynamo);
          } else {
            return parseDynamo(friendship, kFriendshipWithoutMessageDynamo);
          }
        })
      );
    },
  });
}
