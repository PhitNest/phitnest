import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { handleRequest, success } from "typescript-core/src/utils";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    return success();
  });
}
