import { Failure } from "../../common/types";
import { IProfilePicturePublicUserEntity } from "../entities";
import {
  userRepo,
  friendshipRepo,
  friendRequestRepo,
  profilePictureRepo,
} from "../repositories";

export async function explore(cognitoId: string, gymId: string) {
  const [others, friends, sentRequests, receivedRequests] = await Promise.all([
    userRepo.getByGym(gymId),
    friendshipRepo.get(cognitoId),
    friendRequestRepo.getByFromCognitoId(cognitoId),
    friendRequestRepo.getByToCognitoId(cognitoId),
  ]);
  return {
    users: (
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
            const url = await profilePictureRepo.getProfilePictureUrl(
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
    ) as IProfilePicturePublicUserEntity[],
    requests: receivedRequests.filter((request) => !request.denied),
  };
}
