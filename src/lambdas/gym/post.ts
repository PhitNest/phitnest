// @CognitoAuth Admin
import { respond } from "@/common/respond";
import { useDgraph } from "@/common/dgraph";
import { getLocation } from "@/common/open-street-maps";
import { Failure } from "@/common/failure";
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
    controller: async (body: z.infer<typeof validator>) => {
      const location = await getLocation(body);
      if (location instanceof Failure) {
        return location;
      }
      return useDgraph(async (client) => {
        const txn = client.newTxn();
        return await txn.mutate({
          setJson: {
            name: body.name,
            address: {
              street: body.street,
              state: body.state,
              city: body.city,
              zipCode: body.zipCode,
            },
            location: location,
          },
          commitNow: true,
        });
      });
    },
  });
}
