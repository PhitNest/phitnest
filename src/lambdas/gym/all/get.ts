// @CognitoAuth Admin
import { respond } from "../../../common/respond";
import { useDgraph } from "../../../common/dgraph";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";
const gql = String.raw;

const kMaxPageLength = 50;

const validator = z.object({
  limit: z
    .number()
    .int()
    .positive()
    .max(kMaxPageLength)
    .optional()
    .default(kMaxPageLength),
  page: z.number().int().nonnegative().optional().default(0),
});

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return respond({
    body: event.pathParameters,
    validator: validator,
    controller: async (body) => {
      return useDgraph(async (client) => {
        const txn = client.newTxn();
        return (
          await txn.queryGraphQL(
            gql`
              query {
                allGyms(func: has(Gym.name), first: ${body.limit}, offset: ${
              body.page * body.limit
            }){
                  uid
                  Gym.name
                  Gym.street
                  Gym.city
                  Gym.state
                  Gym.zipCode
                  Gym.location
                }
              }
            `
          )
        )["allGyms"];
      });
    },
  });
}
