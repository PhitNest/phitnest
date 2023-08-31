import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  RequestError,
} from "common/utils";
import { getUser } from "common/repositories";
import { createIdentity } from "common/use_cases/create-identity";
import { User } from "common/entities";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    let user: User | RequestError = await getUser(client, userClaims.sub);
    if (user instanceof RequestError) {
      user = await createIdentity(
        client,
        userClaims.sub,
        event.headers.Authorization
      );
      if (user instanceof RequestError) {
        return user;
      }
    }
    return new Success(user);
  });
}
