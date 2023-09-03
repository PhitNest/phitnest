import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  RequestError,
  Success,
  dynamo,
  getUserClaims,
  validateRequest,
} from "typescript-core/src/utils";
import { userInvite } from "typescript-core/src/use-cases";

const validator = z.object({
  receiverEmail: z.string().email(),
});

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const userClaims = getUserClaims(event);
      const client = dynamo();
      const response = await userInvite(client, {
        senderId: userClaims.sub,
        receiverEmail: data.receiverEmail,
      });
      if (response instanceof RequestError) {
        return response;
      }
      return new Success();
    },
  });
}
