import { Failure } from "../../common/types";
import { IPopulatedFriendshipEntity, IPublicUserEntity } from "../entities";
import databases from "../../data/data-sources/injection";

export async function getFriendsAndMessages(cognitoId: string) {
  const me = await databases().userDatabase.get(cognitoId);
  const friendships = await databases()
    .friendshipDatabase.get(cognitoId)
    .then(
      async (friendships) =>
        (
          await Promise.all(
            friendships.map(async (friendship) => {
              const friend = await databases().userDatabase.get(
                friendship.userCognitoIds.find((user) => user !== cognitoId)!
              );
              if (friend instanceof Failure) {
                return friend;
              } else {
                return {
                  ...friendship,
                  friends: [friend, me] as [
                    IPublicUserEntity,
                    IPublicUserEntity
                  ],
                };
              }
            })
          )
        ).filter(
          (friendship) => !(friendship instanceof Failure)
        ) as IPopulatedFriendshipEntity[]
    );
  const message = await Promise.all(
    friendships.map(async (friendship) => {
      const message = await databases().directMessageDatabase.get(
        friendship._id,
        1
      );
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
