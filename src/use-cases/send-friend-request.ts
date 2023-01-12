import {
  kFriendRequestAlreadySent,
  kFriendRequestNotFound,
  kFriendshipAlreadyExists,
  kFriendshipNotFound,
  kUsersHaveDifferentGyms,
} from "../common/failures";
import { Failure } from "../common/types";
import repositories from "../repositories/injection";

export async function sendFriendRequest(
  senderCognitoId: string,
  recipientCognitoId: string
) {
  const { friendshipRepo, friendRequestRepo, userRepo } = repositories();
  const [haveSameGym, sentRequest, receivedRequest, friendship] =
    await Promise.all([
      userRepo.haveSameGym(senderCognitoId, recipientCognitoId),
      friendRequestRepo.getByCognitoIds(senderCognitoId, recipientCognitoId),
      friendRequestRepo.getByCognitoIds(recipientCognitoId, senderCognitoId),
      friendshipRepo.getByUsers([senderCognitoId, recipientCognitoId]),
    ]);
  if (haveSameGym) {
    if (sentRequest instanceof Failure) {
      if (sentRequest === kFriendRequestNotFound) {
        if (friendship instanceof Failure) {
          if (friendship === kFriendshipNotFound) {
            if (receivedRequest instanceof Failure) {
              if (receivedRequest === kFriendRequestNotFound) {
                return friendRequestRepo.create(
                  senderCognitoId,
                  recipientCognitoId
                );
              } else {
                return receivedRequest;
              }
            } else {
              const deletion = await friendRequestRepo.delete(
                recipientCognitoId,
                senderCognitoId
              );
              if (deletion instanceof Failure) {
                return deletion;
              } else {
                return friendshipRepo.create([
                  senderCognitoId,
                  recipientCognitoId,
                ]);
              }
            }
          } else {
            return friendship;
          }
        } else {
          return kFriendshipAlreadyExists;
        }
      } else {
        return sentRequest;
      }
    } else {
      return kFriendRequestAlreadySent;
    }
  } else {
    return kUsersHaveDifferentGyms;
  }
}
