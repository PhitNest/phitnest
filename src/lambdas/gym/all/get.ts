// @CognitoAuth Admin
import { respond } from "../../../common/respond";
import { useDgraph } from "../../../common/dgraph";
import { APIGatewayEvent } from "aws-lambda";
import { paginator } from "../../../common/zod-schema";
import { z } from "zod";
const gql = String.raw;

const validator = z
  .object({
    searchQuery: z.string().optional(),
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
        const searchQuery = body.searchQuery
          ? gql`@filter(anyofterms(Gym.name, "${body.searchQuery}") 
                OR anyofterms(Gym.city, "${body.searchQuery}") 
                OR anyofterms(Gym.state, "${body.searchQuery}")
                OR anyofterms(Gym.zipCode, "${body.searchQuery}")
                OR anyofterms(Gym.street, "${body.searchQuery}"))`
          : "";
        const queryResult = await client.newTxn().query(
          gql`
            query {
              allGyms(func: has(Gym.name), first: ${body.limit}, offset: ${
            body.page * body.limit
          }) ${searchQuery} {
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
              countGyms(func: has(Gym.name)) ${searchQuery} {
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
