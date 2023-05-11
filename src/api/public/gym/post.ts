import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { connectDynamo } from "api/common/dynamo";
import { z } from "zod";
import * as uuid from "uuid";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  try {
    const validator = z.object({
      name: z.string(),
      street: z.string(),
      city: z.string(),
      state: z.string(),
      zipCode: z.string(),
    });
    const body = validator.parse(JSON.parse(event.body || ""));
    const client = connectDynamo();
    const gymId = uuid.v4();
    return {
      statusCode: 200,
      body: JSON.stringify({
        gymId: gymId,
        client: client,
        body: body,
      }),
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify(err),
    };
  }
}
