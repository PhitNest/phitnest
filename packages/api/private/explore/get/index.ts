import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { exploreUsers } from "typescript-core/src/use-cases";
import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  ResourceNotFoundError,
} from "typescript-core/src/utils";

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
