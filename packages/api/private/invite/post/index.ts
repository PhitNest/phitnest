import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  RequestError,
  ResourceNotFoundError,
  Success,
  dynamo,
  getUserClaims,
  validateRequest,
} from "typescript-core/src/utils";
import {
  getReceivedInvites,
  getUser,
  inviteKey,
  userKey,
} from "typescript-core/src/repositories";
import { inviteToDynamo } from "typescript-core/src/entities";

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
      const [sender, existingInvite] = await Promise.all([
        getUser(client, userClaims.sub, userClaims.gymId),
        getReceivedInvites(client, data.receiverEmail, 1),
      ]);
      if (!(existingInvite instanceof ResourceNotFoundError)) {
        return new RequestError("InviteAlreadyExists", "Invite already exists");
      }
      if (sender instanceof ResourceNotFoundError) {
        return sender;
      }
      if (sender.numInvites > 0) {
        await client.writeTransaction({
          updates: [
            {
              ...userKey(userClaims.sub, sender.invite.gymId),
              expression: "SET numInvites = numInvites - 1",
              varMap: {},
            },
          ],
          puts: [
            {
              ...inviteKey("user", userClaims.sub, data.receiverEmail),
              data: inviteToDynamo({
                receiverEmail: data.receiverEmail,
                senderId: userClaims.sub,
                gymId: sender.invite.gymId,
                senderType: "user",
                createdAt: new Date(),
              }),
            },
          ],
        });
      } else {
        return new RequestError("NoInvites", "No invites available");
      }
      return new Success();
    },
  });
}
