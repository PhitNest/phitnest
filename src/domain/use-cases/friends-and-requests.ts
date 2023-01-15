import { Failure } from "../../common/types";
import {
  IPopulatedFriendRequestEntity,
  IPopulatedFriendshipEntity,
} from "../entities";
import { friendshipRepo, friendRequestRepo, userRepo } from "../repositories";

export async function getFriendsAndFriendRequests(cognitoId: string) {
  const [friends, friendRequests] = await Promise.all([
    friendshipRepo.get(cognitoId).then(
      async (friendships) =>
        (
          await Promise.all(
            friendships.map((friendship) => {
              const friendCognitoId = friendship.userCognitoIds.find(
                (user) => user !== cognitoId
              )!;
              return userRepo.get(friendCognitoId);
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
    friendRequestRepo.getByToCognitoId(cognitoId).then((friendRequests) =>
      Promise.all(
        friendRequests.map(async (friendRequest) => {
          return {
            ...friendRequest,
            fromUser: await userRepo.get(friendRequest.fromCognitoId),
          };
        })
      ).then(
        (friendRequests) =>
          friendRequests.filter(
            (friendRequest) => !(friendRequest.fromUser instanceof Failure)
          ) as IPopulatedFriendRequestEntity[]
      )
    ),
  ]);
  return {
    friendships: friends,
    requests: friendRequests,
  };
}
