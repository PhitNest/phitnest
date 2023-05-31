import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { PutItemCommand } from "@aws-sdk/client-dynamodb";
import { z } from "zod";
import { validateRequest, connectDynamo, getLocation } from "api/common/utils";
import { Gym, gymToDynamo } from "api/common/entities";
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
          const client = connectDynamo();
          const gymId = uuid.v4();
          const gym: Gym = {
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
          };
          await client.send(
            new PutItemCommand({
              TableName: process.env.DYNAMO_TABLE_NAME,
              Item: {
                part_id: { S: "GYMS" },
                sort_id: { S: `GYM#${gymId}` },
                ...gymToDynamo(gym),
              },
            })
          );
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
