import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { client } from "api/common/dynamo";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return {
    statusCode: 200,
    body: `${client.config} + ${
      process.env.DYNAMO_TABLE_NAME
    }: ${JSON.stringify(event)}`,
  };
}
