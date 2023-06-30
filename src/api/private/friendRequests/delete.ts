import {
  dynamo,
  validateRequest,
  Success,
  getUserClaims,
} from "api/common/utils";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  userId: z.string(),
  friendId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: {
      userId: getUserClaims(event)?.sub,
      ...JSON.parse(event.body ?? "{}"),
    },
    validator: validator,
    controller: async (data) => {
      const client = dynamo().connect();
      await client.writeTransaction({
        deletes: [
          {
            pk: `USER#${data.friendId}`,
            sk: `FRIEND_REQUEST#${data.userId}`,
          },
          {
            pk: `INCOMING_REQUEST#${data.userId}`,
            sk: `SENDER#${data.friendId}`,
          },
        ],
        puts: [],
        updates: [],
      });
      return new Success();
    },
  });
}
