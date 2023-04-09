// @CognitoAuth Admin
import { respond } from "common/respond";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";
import { useDgraph } from "common/dgraph";
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
        txn.queryGraphQL(gql`
          query {
            allGyms(skip: ${body.page * body.limit}, first: ${body.limit}) {
              uid
              name
              street
              city
              state
              zipCode
              location
            }
          }
        `);
      });
    },
  });
}
