import { Failure } from "../../common/types";
import { IProfilePicturePublicUserEntity } from "../entities";
import databases from "../../data/data-sources/injection";

export async function explore(cognitoId: string, gymId: string) {
  const [others, friends, sentRequests, receivedRequests] = await Promise.all([
    databases().userDatabase.getByGym(gymId),
    databases().friendshipDatabase.get(cognitoId),
    databases().friendRequestDatabase.getByFromCognitoId(cognitoId),
    databases().friendRequestDatabase.getByToCognitoId(cognitoId),
  ]);
  return (
    await Promise.all(
      others
        .filter(
          (user) =>
            !(
              user.cognitoId === cognitoId ||
              !user.confirmed ||
              friends.find((friendship) =>
                friendship.userCognitoIds.includes(user.cognitoId)
              ) ||
              sentRequests.find(
                (request) => request.toCognitoId === user.cognitoId
              ) ||
              receivedRequests.find(
                (request) =>
                  request.fromCognitoId === user.cognitoId && request.denied
              )
            )
        )
        .map(async (user) => {
          const url =
            await databases().profilePictureDatabase.getProfilePictureUrl(
              user.cognitoId
            );
          if (url instanceof Failure) {
            return url;
          } else {
            return {
              ...user,
              profilePictureUrl: url,
            };
          }
        })
    )
  ).filter(
    (user) => !(user instanceof Failure)
  ) as IProfilePicturePublicUserEntity[];
}
