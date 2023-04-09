// @CognitoAuth Admin
import { respond } from "common/respond";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";

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
      return body;
    },
  });
}
