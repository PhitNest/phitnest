import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  RequestError,
  Success,
  dynamo,
  getAdminClaims,
  validateRequest,
} from "typescript-core/src/utils"
import { adminInvite } from "typescript-core/src/use-cases";

const validator = z.object({
  receiverEmail: z.string().email(),
  gymId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const adminClaims = getAdminClaims(event);
      const client = dynamo();
      const error = await adminInvite(client, {
        senderId: adminClaims.sub,
        receiverEmail: data.receiverEmail,
        gymId: data.gymId,
      });
      if (error instanceof RequestError) {
        return error;
      }
      return new Success();
    },
  });
}
