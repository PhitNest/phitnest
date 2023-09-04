import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  getExploreUsers,
  getFriendships,
} from "typescript-core/src/repositories";
import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  ResourceNotFoundError,
  RequestError,
} from "typescript-core/src/utils";

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const [othersAtGym, friendships] = await Promise.all([
      getExploreUsers(client, userClaims.gymId),
      getFriendships(client, userClaims.sub),
    ]);
    if (friendships instanceof RequestError) {
      return friendships;
    }
    const removeUserIds = new Set<string>([userClaims.sub]);
    for (const friendship of friendships) {
      if (friendship.__poly__ === "FriendRequest") {
        if (userClaims.sub === friendship.sender.id) {
          removeUserIds.add(friendship.receiver.id);
        }
      } else {
        removeUserIds.add(friendship.sender.id);
        removeUserIds.add(friendship.receiver.id);
      }
    }
    const users = await Promise.all(
      othersAtGym.filter((other) => !removeUserIds.has(other.id)),
    );
    if (users instanceof ResourceNotFoundError) {
      return users;
    } else {
      return new Success(users);
    }
  });
}
