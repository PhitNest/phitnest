import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  validateRequest,
  getLocation,
  dynamo,
  Success,
  OpenStreetMapError,
  getAdminClaims,
  CognitoClaimsError,
} from "common/utils";
import { gymToDynamo } from "common/entities";
import * as uuid from "uuid";

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
      if (adminClaims instanceof CognitoClaimsError) {
        return adminClaims;
      } else {
        const location = await getLocation(data);
        if (location instanceof OpenStreetMapError) {
          return location;
        } else {
          const client = dynamo().connect();
          const gymId = uuid.v4();
          await client.put({
            pk: "GYMS",
            sk: `GYM#${gymId}`,
            data: gymToDynamo({
              id: gymId,
              createdAt: new Date(),
              adminEmail: adminClaims.email,
              gymName: data.name,
              address: {
                street: data.street,
                city: data.city,
                state: data.state,
                zipCode: data.zipCode,
              },
              gymLocation: location,
            }),
          });
          return new Success({
            gymId: gymId,
            location: location,
          });
        }
      }
    },
  });
}
