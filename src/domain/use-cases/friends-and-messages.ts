import { Failure } from "../../common/types";
import { IPopulatedFriendshipEntity } from "../entities";
import { friendshipRepo, directMessageRepo, userRepo } from "../repositories";

export async function getFriendsAndMessages(cognitoId: string) {
  const friendships = await friendshipRepo.get(cognitoId).then(
    async (friendships) =>
      (
        await Promise.all(
          friendships.map(async (friendship) => {
            return {
              ...friendship,
              friend: await userRepo.get(
                friendship.userCognitoIds.find((user) => user !== cognitoId)!
              ),
            };
          })
        )
      ).filter(
        (friendship) => !(friendship.friend instanceof Failure)
      ) as IPopulatedFriendshipEntity[]
  );
  const message = await Promise.all(
    friendships.map(async (friendship) => {
      const message = await directMessageRepo.get(friendship._id, 1);
      if (message.length > 0) {
        return message[0];
      } else {
        return undefined;
      }
    })
  );
  return friendships
    .map((friendship, i) => {
      return {
        friendship: friendship,
        message: message[i],
      };
    })
    .sort((a, b) => {
      const aTime = a.message
        ? a.message.createdAt.getTime()
        : a.friendship.createdAt.getTime();
      const bTime = b.message
        ? b.message.createdAt.getTime()
        : b.friendship.createdAt.getTime();
      return bTime - aTime;
    });
}
