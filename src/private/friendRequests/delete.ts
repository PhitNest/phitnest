import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import { dynamo, validateRequest, Success, getUserClaims } from "common/utils";
import { deleteFriendRequest } from "common/repositories";

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
      await deleteFriendRequest(client, userClaims.sub, data.friendId);
      return new Success();
    },
  });
}
