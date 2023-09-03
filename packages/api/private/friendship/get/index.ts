import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { getFriendships } from "typescript-core/src/repositories";
import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  RequestError,
} from "typescript-core/src/utils";

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const response = await getFriendships(client, userClaims.sub);
    if (response instanceof RequestError) {
      return response;
    }
    return new Success(response);
  });
}
