import { UserExplore } from "common/entities";
import { getExploreUsers, getFriendships, getUser } from "common/repositories";
import {
  DynamoClient,
  RequestError,
  ResourceNotFoundError,
} from "common/utils";

export async function exploreUsers(
  dynamo: DynamoClient,
  userId: string
): Promise<UserExplore[] | ResourceNotFoundError> {
  const user = await getUser(dynamo, userId);
  if (user instanceof ResourceNotFoundError) {
    return user;
  } else {
    const [othersAtGym, friendships] = await Promise.all([
      getExploreUsers(dynamo, user.invite.gymId),
      getFriendships(dynamo, user.id),
    ]);
    if (friendships instanceof RequestError) {
      return friendships;
    }
    const removeUserIds = new Set<string>();
    for (const friendship of friendships) {
      if (friendship.__poly__ === "FriendRequest") {
        if (user.id === friendship.sender.id) {
          removeUserIds.add(friendship.receiver.id);
        }
      } else {
        removeUserIds.add(friendship.sender.id);
        removeUserIds.add(friendship.receiver.id);
      }
    }
    return await Promise.all(
      othersAtGym.filter((other) => !removeUserIds.has(other.id))
    );
  }
}
