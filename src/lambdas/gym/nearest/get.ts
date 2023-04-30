// @CognitoAuth User
import { respond } from "../../../common/respond";
import { APIGatewayEvent } from "aws-lambda";
import { paginator } from "common/zod-schema";
import { z } from "zod";

const validator = z
  .object({
    longitude: z.number().min(-180).max(180),
    latitude: z.number().min(-90).max(90),
  })
  .merge(paginator);

export function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return respond(
    event,
    async (body) => {
      return body;
    },
    validator
  );
}
