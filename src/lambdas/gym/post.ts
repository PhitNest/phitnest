// @CognitoAuth Admin
import { respond } from "../../common/respond";
import { getLocation } from "../../common/open-street-maps";
import { Failure } from "../../common/failures";
import { useDgraph } from "../../common/dgraph";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";
import { Gym } from "../../generated/dgraph-schema";

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
  return respond(
    event,
    async (body) => {
      const location = await getLocation(body);
      if (location instanceof Failure) {
        return location;
      }
      return await useDgraph((client) => {
        return client.newTxn().mutate<Gym>({
          obj: {
            "Gym.name": body.name,
            "Gym.street": body.street,
            "Gym.city": body.city,
            "Gym.state": body.state,
            "Gym.zipCode": body.zipCode,
            "Gym.location": {
              type: "Point",
              coordinates: [location.latitude, location.longitude],
            },
          },
          commitNow: true,
        });
      });
    },
    validator
  );
}
