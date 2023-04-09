// @CognitoAuth Admin
import { respond } from "common/respond";
import { getLocation } from "common/open-street-maps";
import { Failure } from "common/failures";
import { useDgraph } from "common/dgraph";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  street: z.string(),
  city: z.string(),
  state: z.string(),
  zipCode: z.string(),
  name: z.string(),
});

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return respond({
    body: event.body,
    validator: validator,
    controller: async (body) => {
      const location = await getLocation(body);
      if (location instanceof Failure) {
        return location;
      }
      return await useDgraph((client) => {
        return client.newTxn().mutateGraphQL({
          obj: {
            __typename: "Gym",
            name: body.name,
            street: body.street,
            city: body.city,
            state: body.state,
            zipCode: body.zipCode,
            location: {
              __typename: "Location",
              latitude: location.latitude,
              longitude: location.longitude,
            },
          },
          commitNow: true,
        });
      });
    },
  });
}
