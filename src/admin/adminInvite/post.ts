import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  ResourceNotFoundError,
  Success,
  dynamo,
  getAdminClaims,
  validateRequest,
} from "common/utils";
import { adminInviteToDynamo, kGymWithoutAdminParser } from "common/entities";

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
      const gym = await client.parsedQuery({
        pk: "GYMS",
        sk: { q: `GYM#${data.gymId}`, op: "EQ" },
        parseShape: kGymWithoutAdminParser,
      });
      if (gym instanceof ResourceNotFoundError) {
        return gym;
      } else {
        await client.put({
          pk: `INVITE#${adminClaims.email}`,
          sk: `RECEIVER#${data.receiverEmail}`,
          data: adminInviteToDynamo({
            type: "admin",
            receiverEmail: data.receiverEmail,
            inviter: {
              email: adminClaims.email,
              id: adminClaims.sub,
            },
            createdAt: new Date(),
            gym: gym,
          }),
        });
        return new Success();
      }
    },
  });
}
