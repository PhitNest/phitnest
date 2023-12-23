import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  deleteFriendship,
  deleteUser,
  getFriendships,
  getUser,
} from "typescript-core/src/repositories";
import {
  dynamo,
  handleRequest,
  getUserClaims,
  isResourceNotFound,
  success,
} from "typescript-core/src/utils";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const [friendships, user] = await Promise.all([
      getFriendships(client, userClaims.sub),
      getUser(client, userClaims.sub),
    ]);
    if (isResourceNotFound(friendships)) {
      return friendships;
    } else if (isResourceNotFound(user)) {
      return user;
    } else {
      await Promise.all([
        deleteUser(client, userClaims.sub),
        ...friendships.flatMap((friendship) => [
          deleteFriendship(
            client,
            friendship.sender.id,
            friendship.receiver.id
          ),
          deleteFriendship(
            client,
            friendship.receiver.id,
            friendship.sender.id
          ),
        ]),
      ]);
    }
    return success();
  });
}
