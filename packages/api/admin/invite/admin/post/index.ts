import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  dynamo,
  getAdminClaims,
  isResourceNotFound,
  requestError,
  success,
  validateRequest,
} from "typescript-core/src/utils";
import {
  getGym,
  getReceivedInvites,
  inviteKey,
} from "typescript-core/src/repositories";
import { inviteToDynamo } from "typescript-core/src/entities";

const validator = z.object({
  receiverEmail: z.string().email(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const adminClaims = getAdminClaims(event);
      const client = dynamo();
      const [gym, existingInvite] = await Promise.all([
        getGym(client, adminClaims.sub),
        getReceivedInvites(client, data.receiverEmail, 1),
      ]);
      if (!isResourceNotFound(existingInvite)) {
        return requestError("InviteAlreadyExists", "Invite already exists");
      }
      if (isResourceNotFound(gym)) {
        return gym;
      }
      await client.put({
        ...inviteKey(
          "admin",
          adminClaims.sub,
          data.receiverEmail.toLowerCase()
        ),
        data: inviteToDynamo({
          receiverEmail: data.receiverEmail.toLowerCase(),
          senderId: adminClaims.sub,
          gymId: adminClaims.sub,
          senderType: "admin",
          createdAt: new Date(),
        }),
      });
      return success();
    },
  });
}
