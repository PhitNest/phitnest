import { APIGatewayProxyResult } from "aws-lambda";
// @ts-ignore
import { myString } from "common/nested/transpileThis";
import isOdd from "is-odd";
import isEven from "is-even";

export async function invoke(
  event: APIGatewayProxyResult
): Promise<APIGatewayProxyResult> {
  return {
    statusCode: isOdd(JSON.parse(event.body || myString).age || 3)
      ? 200
      : isEven(JSON.parse(event.body || "").age || 4)
      ? 200
      : 500,
    body: JSON.stringify(event),
  };
}
