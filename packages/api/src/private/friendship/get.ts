import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { getFriendships } from "common/repositories";
import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  RequestError,
} from "common/utils";

export async function invoke(
  event: APIGatewayEvent
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
