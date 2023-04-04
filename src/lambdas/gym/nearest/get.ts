// @CognitoAuth User
import { respond } from "../../../common/respond";
import { APIGatewayEvent } from "aws-lambda";
import { z } from "zod";

const validator = z.object({
  longitude: z.number().min(-180).max(180),
  latitude: z.number().min(-90).max(90),
});

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return respond({
    body: event.queryStringParameters,
    validator: validator,
    controller: async (body: z.infer<typeof validator>) => {
      return body;
    },
  });
}
