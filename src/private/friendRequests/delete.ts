import { dynamo, validateRequest, Success, getUserClaims } from "common/utils";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  friendId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const userClaims = getUserClaims(event);
      const client = dynamo();
      await client.delete({
        pk: `USER#${userClaims.sub}`,
        sk: `FRIEND_REQUEST#${data.friendId}`,
      });
      return new Success();
    },
  });
}
