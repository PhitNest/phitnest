import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  dynamo,
  validateRequest,
  getUserClaims,
  RequestError,
  Success,
} from "common/utils";
import { sendFriendRequest } from "common/use_cases/send-friend-request";

const validator = z.object({
  receiverId: z.string(),
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
      const result = await sendFriendRequest(
        client,
        userClaims.sub,
        data.receiverId
      );
      if (result instanceof RequestError) {
        return result;
      }
      return new Success(result);
    },
  });
}
