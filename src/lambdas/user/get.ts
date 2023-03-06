// @CognitoAuth User
import { APIGatewayEvent } from "aws-lambda";

export async function invoke(event: APIGatewayEvent): Promise<{
  statusCode: number;
  body: string;
}> {
  return {
    statusCode: 200,
    body: JSON.stringify(event),
  };
}
