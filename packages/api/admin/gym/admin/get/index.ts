import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  dynamo,
  getAdminClaims,
  handleRequest,
  isResourceNotFound,
  success,
} from "typescript-core/src/utils";
import { getGym } from "typescript-core/src/repositories";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const adminClaims = getAdminClaims(event);
    const client = dynamo();
    const gym = await getGym(client, adminClaims.sub);
    if (isResourceNotFound(gym)) {
      return gym;
    }
    return success(gym);
  });
}
