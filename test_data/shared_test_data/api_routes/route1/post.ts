import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import isOdd from "is-odd";
import isEven from "is-even";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return {
    statusCode: isOdd(JSON.parse(event.body || "").age || 3)
      ? 200
      : isEven(JSON.parse(event.body || "").age || 4)
      ? 200
      : 500,
    body: JSON.stringify(event),
  };
}
