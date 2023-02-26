import { Failure } from "../../common/types";
import {
  IPopulatedFriendRequestEntity,
  IPopulatedFriendshipEntity,
} from "../entities";
import databases from "../../data/data-sources/injection";

export async function getFriendsAndFriendRequests(cognitoId: string) {
  const [friends, friendRequests] = await Promise.all([
    databases()
      .friendshipDatabase.get(cognitoId)
      .then(
        async (friendships) =>
          (
            await Promise.all(
              friendships.map((friendship) => {
                const friendCognitoId = friendship.userCognitoIds.find(
                  (user) => user !== cognitoId
                )!;
                return databases().userDatabase.get(friendCognitoId);
              })
            )
          )
            .map((friend, i) => {
              return {
                ...friendships[i],
                friend: friend,
              };
            })
            .filter(
              (friendship) => !(friendship.friend instanceof Failure)
            ) as IPopulatedFriendshipEntity[]
      ),
    databases()
      .friendRequestDatabase.getByToCognitoId(cognitoId)
      .then((friendRequests) =>
        Promise.all(
          friendRequests.map(async (friendRequest) => {
            return {
              ...friendRequest,
              fromUser: await databases().userDatabase.get(
                friendRequest.fromCognitoId
              ),
            };
          })
        ).then(
          (friendRequests) =>
            friendRequests.filter(
              (friendRequest) =>
                !(friendRequest.fromUser instanceof Failure) &&
                !friendRequest.denied
            ) as IPopulatedFriendRequestEntity[]
        )
      ),
  ]);
  return {
    friendships: friends,
    requests: friendRequests,
  };
}
