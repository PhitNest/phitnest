import {
  kFriendRequestAlreadySent,
  kFriendRequestNotFound,
  kFriendshipAlreadyExists,
  kFriendshipNotFound,
  kUsersHaveDifferentGyms,
} from "../../common/failures";
import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";

export async function sendFriendRequest(
  senderCognitoId: string,
  recipientCognitoId: string
) {
  const [haveSameGym, sentRequest, receivedRequest, friendship] =
    await Promise.all([
      databases().userDatabase.haveSameGym(senderCognitoId, recipientCognitoId),
      databases().friendRequestDatabase.getByCognitoIds(
        senderCognitoId,
        recipientCognitoId
      ),
      databases().friendRequestDatabase.getByCognitoIds(
        recipientCognitoId,
        senderCognitoId
      ),
      databases().friendshipDatabase.getByUsers([
        senderCognitoId,
        recipientCognitoId,
      ]),
    ]);
  if (haveSameGym) {
    if (sentRequest instanceof Failure) {
      if (sentRequest === kFriendRequestNotFound) {
        if (friendship instanceof Failure) {
          if (friendship === kFriendshipNotFound) {
            if (receivedRequest instanceof Failure) {
              if (receivedRequest === kFriendRequestNotFound) {
                return databases().friendRequestDatabase.create(
                  senderCognitoId,
                  recipientCognitoId
                );
              } else {
                return receivedRequest;
              }
            } else {
              const deletion = await databases().friendRequestDatabase.delete(
                recipientCognitoId,
                senderCognitoId
              );
              if (deletion instanceof Failure) {
                return deletion;
              } else {
                return databases().friendshipDatabase.create([
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
