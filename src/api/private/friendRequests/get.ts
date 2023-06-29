import {
  dynamo,
  validateRequest,
  Success,
  getUserClaims,
} from "api/common/utils";
import { kFriendRequestDynamo } from "api/common/entities";
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
      const friendRequests = await client.parsedQuery({
        pk: `INCOMING_REQUEST#${data.userId}`,
        sk: { q: "SENDER#", op: "BEGINS_WITH" },
        parseShape: kFriendRequestDynamo,
      });
      return new Success(friendRequests);
    },
  });
}
