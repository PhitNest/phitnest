import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import { RequestError, Success, dynamo, validateRequest } from "common/utils";

const validator = z.object({
  id: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const client = dynamo().connect();
      const id = await client.parsedQuery({
        pk: "IDENTITY_ID",
        sk: { q: `ID#${data.id}`, op: "EQ" },
        parseShape: {
          id: "S",
        },
      });
      if (id instanceof RequestError) {
        return id;
      } else {
        return new Success(id);
      }
    },
  });
}
