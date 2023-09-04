import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  ResourceNotFoundError,
  Success,
  dynamo,
  getAdminClaims,
  handleRequest,
} from "typescript-core/src/utils";
import { getGym } from "typescript-core/src/repositories";

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const adminClaims = getAdminClaims(event);
    const client = dynamo();
    const gym = await getGym(client, adminClaims.sub);
    if (gym instanceof ResourceNotFoundError) {
      return gym;
    }
    return new Success(gym);
  });
}
