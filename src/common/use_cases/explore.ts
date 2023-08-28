import { UserExplore } from "common/entities";
import {
  getExploreUsers,
  getFriendships,
  getSentFriendRequests,
  getUser,
} from "common/repository";
import { DynamoClient, ResourceNotFoundError } from "common/utils";

export async function exploreUsers(
  dynamo: DynamoClient,
  userId: string
): Promise<UserExplore[] | ResourceNotFoundError> {
  const user = await getUser(dynamo, userId);
  if (user instanceof ResourceNotFoundError) {
    return user;
  } else {
    const [othersAtGym, friendships, sentFriendRequests] = await Promise.all([
      getExploreUsers(dynamo, user.invite.gymId),
      getFriendships(dynamo, user.id),
      getSentFriendRequests(dynamo, user.id),
    ]);
    const exploreResponse = await Promise.all(
      othersAtGym.filter((other) => {
        const isMe = other.id === user.id;
        const sentRequest = sentFriendRequests.some(
          (friendship) => friendship.receiver.id === other.id
        );
        const isFriend = friendships.some(
          (friendship) =>
            friendship.receiver.id === other.id ||
            friendship.sender.id === other.id
        );
        return !isMe && !sentRequest && !isFriend;
      })
    );
    return exploreResponse;
  }
}
