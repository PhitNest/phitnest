import { Failure } from "../../common/types";
import {
  IPopulatedFriendRequestEntity,
  IPopulatedFriendshipEntity,
  IPublicUserEntity,
} from "../entities";
import databases from "../../data/data-sources/injection";

export async function getFriendsAndFriendRequests(cognitoId: string) {
  const me = await databases().userDatabase.get(cognitoId);
  const [friends, friendRequests] = await Promise.all([
    databases()
      .friendshipDatabase.get(cognitoId)
      .then(
        async (friendships) =>
          (
            await Promise.all(
              friendships.map(async (friendship) => {
                const friendCognitoId = friendship.userCognitoIds.find(
                  (user) => user !== cognitoId
                )!;
                const friend = await databases().userDatabase.get(
                  friendCognitoId
                );
                if (friend instanceof Failure) {
                  return friend;
                } else {
                  return [friend, me] as [IPublicUserEntity, IPublicUserEntity];
                }
              })
            )
          )
            .map((friends, i) => {
              return {
                ...friendships[i],
                friends: friends,
              };
            })
            .filter(
              (friendship) => !(friendship.friends instanceof Failure)
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
              toUser: me,
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
