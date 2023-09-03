import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { deleteUserAccount } from "typescript-core/src/use-cases";
import {
  dynamo,
  Success,
  handleRequest,
  getUserClaims,
  ResourceNotFoundError,
} from "typescript-core/src/utils";

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const error = await deleteUserAccount(client, userClaims.sub);
    if (error instanceof ResourceNotFoundError) {
      return error;
    }
    return new Success();
  });
}
