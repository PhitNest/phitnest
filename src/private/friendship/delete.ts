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
      await Promise.all([
        client.delete({
          pk: `USER#${userClaims.sub}`,
          sk: `FRIENDSHIP#${data.friendId}`,
        }),
        client.delete({
          pk: `USER#${data.friendId}`,
          sk: `FRIENDSHIP#${userClaims.sub}`,
        }),
      ]);
      return new Success();
    },
  });
}
