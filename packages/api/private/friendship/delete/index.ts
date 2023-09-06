import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  dynamo,
  validateRequest,
  Success,
  getUserClaims,
} from "typescript-core/src/utils";
import { deleteFriendship } from "typescript-core/src/repositories";

const validator = z.object({
  friendId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: { ...event.queryStringParameters },
    validator: validator,
    controller: async (data) => {
      const userClaims = getUserClaims(event);
      const client = dynamo();
      await Promise.all([
        deleteFriendship(client, userClaims.sub, data.friendId),
        deleteFriendship(client, data.friendId, userClaims.sub),
      ]);
      return new Success();
    },
  });
}
