import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import { validateRequest, getLocation, dynamo } from "api/common/utils";
import { gymToDynamo } from "api/common/entities";
import * as uuid from "uuid";

export const kUnableToFindLocation = {
  message: "Unable to fetch gym location",
};

export const kNoAdminClaims = {
  message: "No admin claims found",
};

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
      if (event.requestContext.authorizer) {
        const location = await getLocation(data);
        if (location) {
          const client = dynamo().connect();
          const gymId = uuid.v4();
          await client.put({
            pk: "GYMS",
            sk: `GYM#${gymId}`,
            data: gymToDynamo({
              id: gymId,
              createdAt: new Date(),
              adminEmail: event.requestContext.authorizer.claims.email,
              name: data.name,
              address: {
                street: data.street,
                city: data.city,
                state: data.state,
                zipCode: data.zipCode,
              },
              location: location,
            }),
          });
          return {
            statusCode: 200,
            body: JSON.stringify({
              gymId: gymId,
              location: location,
            }),
          };
        } else {
          throw kUnableToFindLocation;
        }
      } else {
        throw kNoAdminClaims;
      }
    },
  });
}
