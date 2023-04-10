// @CognitoAuth Admin
import { respond } from "../../../common/respond";
import { useDgraph } from "../../../common/dgraph";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";
const gql = String.raw;

const kDefaultPageLength = 50;

const validator = z.object({
  limit: z.number().int().optional().default(kDefaultPageLength),
  page: z.number().int().optional().default(0),
});

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return respond({
    body: event.body,
    validator: validator,
    controller: async (body) => {
      return useDgraph(async (client) => {
        const txn = client.newTxn();
        return (
          await txn.queryGraphQL(gql`
          query {
            allGyms(skip: ${body.page * body.limit}, first: ${body.limit}) {
              uid
              Gym.name
              Gym.street
              Gym.city
              Gym.state
              Gym.zipCode
              Gym.location
            }
          }
        `)
        )["allGyms"];
      });
    },
  });
}
