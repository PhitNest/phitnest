import { z } from "zod";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  validateRequest,
  dynamo,
  Success,
  getAdminClaims,
  RequestError,
} from "common/utils";
import { createGym } from "common/use_cases";

const validator = z.object({
  name: z.string(),
  street: z.string(),
  city: z.string(),
  state: z.string(),
  zipCode: z.string(),
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
      const gym = await createGym(client, {
        adminEmail: adminClaims.email,
        name: data.name,
        address: data,
      });
      if (gym instanceof RequestError) {
        return gym;
      }
      return new Success({
        gymId: gym.id,
        location: gym.gymLocation,
      });
    },
  });
}
