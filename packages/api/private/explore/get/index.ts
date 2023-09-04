import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  getExploreUsers,
  getFriendships,
  getUser,
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
    const user = await getUser(client, userClaims.sub);
    if (user instanceof ResourceNotFoundError) {
      return user;
    }
    const [othersAtGym, friendships] = await Promise.all([
      getExploreUsers(client, user.invite.gymId),
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
