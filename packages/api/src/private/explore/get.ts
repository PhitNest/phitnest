import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { exploreUsers } from "common/use_cases";
import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  ResourceNotFoundError,
} from "common/utils";

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const users = await exploreUsers(client, userClaims.sub);
    if (users instanceof ResourceNotFoundError) {
      return users;
    } else {
      return new Success(users);
    }
  });
}
