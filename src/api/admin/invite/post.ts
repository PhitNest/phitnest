import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  RequestError,
  Success,
  dynamo,
  getAdminClaims,
  kInvalidParameter,
  validateRequest,
} from "api/common/utils";
import {
  adminInviteToDynamo,
  kGymWithoutAdminDynamo,
} from "api/common/entities";

const validator = z.object({
  adminEmail: z.string(),
  receiverEmail: z.string().email(),
  gymId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: {
      ...JSON.parse(event.body ?? "{}"),
      adminEmail: getAdminClaims(event)?.email,
    },
    validator: validator,
    controller: async (data) => {
      const client = dynamo().connect();
      const gym = await client.parsedQuery({
        pk: "GYMS",
        sk: { q: `GYM#${data.gymId}`, op: "EQ" },
        parseShape: kGymWithoutAdminDynamo,
      });
      if (gym) {
        await client.put({
          pk: `INVITE#${data.adminEmail}`,
          sk: `RECEIVER#${data.receiverEmail}`,
          data: adminInviteToDynamo({
            type: "admin",
            receiverEmail: data.receiverEmail,
            inviter: {
              adminEmail: data.adminEmail,
            },
            createdAt: new Date(),
            gym: gym,
          }),
        });
        return new Success();
      } else {
        return new RequestError(
          kInvalidParameter,
          "Could not find a gym with the provided gym id"
        );
      }
    },
  });
}
