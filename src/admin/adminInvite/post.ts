import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  RequestError,
  ResourceNotFoundError,
  Success,
  dynamo,
  getAdminClaims,
  validateRequest,
} from "common/utils";
import { inviteToDynamo, kGymParser, kInviteParser } from "common/entities";

const validator = z.object({
  receiverEmail: z.string().email(),
  gymId: z.string(),
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
        client.parsedQuery({
          pk: "GYMS",
          sk: { q: `GYM#${data.gymId}`, op: "EQ" },
          parseShape: kGymParser,
        }),
        client.parsedQuery({
          pk: `INVITE#${data.receiverEmail}`,
          sk: {
            q: `ADMIN#`,
            op: "BEGINS_WITH",
          },
          limit: 1,
          table: "inverted",
          parseShape: kInviteParser,
        }),
      ]);
      if (!(existingInvite instanceof ResourceNotFoundError)) {
        return new RequestError("InviteAlreadyExists", "Invite already exists");
      }
      if (gym instanceof ResourceNotFoundError) {
        return gym;
      } else {
        await client.put({
          pk: `ADMIN#${adminClaims.sub}`,
          sk: `INVITE#${data.receiverEmail}`,
          data: inviteToDynamo({
            type: "admin",
            receiverEmail: data.receiverEmail,
            senderId: adminClaims.sub,
            createdAt: new Date(),
            gymId: gym.id,
          }),
        });
        return new Success();
      }
    },
  });
}
