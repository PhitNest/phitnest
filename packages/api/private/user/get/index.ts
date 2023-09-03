import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  RequestError,
} from "typescript-core/src/utils";
import { getUser } from "typescript-core/src/repositories";
import { createIdentity } from "typescript-core/src/use-cases/create-identity";
import { User } from "typescript-core/src/entities";

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    let user: User | RequestError = await getUser(client, userClaims.sub);
    if (user instanceof RequestError) {
      user = await createIdentity(
        client,
        userClaims.sub,
        event.headers.Authorization,
      );
      if (user instanceof RequestError) {
        return user;
      }
    }
    return new Success(user);
  });
}
