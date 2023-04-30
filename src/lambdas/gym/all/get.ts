// @CognitoAuth Admin
import { respond } from "../../../common/respond";
import { useDgraph } from "../../../common/dgraph";
import { APIGatewayEvent } from "aws-lambda";
import { paginator } from "../../../common/zod-schema";
import { z } from "zod";
const gql = String.raw;

const validator = z
  .object({
    searchQuery: z.string().optional().default(""),
  })
  .merge(paginator);

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return respond(
    event,
    async (body) => {
      return await useDgraph(async (client) => {
        const searchQuery = gql`has(Gym.name) AND anyofterms(${body.searchQuery})`;
        const queryResult = await client.newTxn().query(
          gql`
            query {
              allGyms(func: ${searchQuery}, first: ${body.limit}, offset: ${
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

            query {
              countGyms(func: ${searchQuery}) {
                count(uid)
              }
            }
          `
        );
        return {
          gyms: queryResult["allGyms"],
          count: queryResult["countGyms"][0][""],
        };
      });
    },
    validator
  );
}
