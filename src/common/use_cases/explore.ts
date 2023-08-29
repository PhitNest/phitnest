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
    return await Promise.all(
      othersAtGym.filter((other) => {
        return (
          user.id !== other.id &&
          !friendships.some(
            (friendship) =>
              friendship.receiver.id === other.id ||
              friendship.sender.id === other.id
          )
        );
      })
    );
  }
}
