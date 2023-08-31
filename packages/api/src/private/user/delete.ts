import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { deleteUserAccount } from "common/use_cases";
import {
  dynamo,
  Success,
  handleRequest,
  getUserClaims,
  ResourceNotFoundError,
} from "common/utils";

export async function invoke(
  event: APIGatewayEvent
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
