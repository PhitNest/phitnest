import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { test } from "common/dynamo";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return {
    statusCode: 200,
    body: `${test}: ${JSON.stringify(event)}`,
  };
}
