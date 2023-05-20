import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { PutItemCommand } from "@aws-sdk/client-dynamodb";
import { z } from "zod";
import { validateRequest, connectDynamo, getLocation } from "api/common/utils";
import * as uuid from "uuid";

export const UNABLE_TO_FIND_LOCATION_MSG = "Unable to fetch gym location";

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
      const location = await getLocation(data);
      if (location) {
        const client = connectDynamo();
        const gymId = uuid.v4();
        await client.send(
          new PutItemCommand({
            TableName: process.env.DYNAMO_TABLE_NAME,
            Item: {
              part_id: { S: "GYMS" },
              sort_id: { S: `GYM#${gymId}` },
              name: { S: data.name },
              address: {
                M: {
                  street: { S: data.street },
                  city: { S: data.city },
                  state: { S: data.state },
                  zipCode: { S: data.zipCode },
                },
              },
              location: {
                M: {
                  latitude: { N: location.latitude.toString() },
                  longitude: { N: location.longitude.toString() },
                },
              },
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
        return {
          statusCode: 500,
          headers: {
            "Content-Type": "text/plain",
          },
          body: UNABLE_TO_FIND_LOCATION_MSG,
        };
      }
    },
  });
}
