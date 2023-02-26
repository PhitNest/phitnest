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
  const [sender, recipient, sentRequest, receivedRequest, friendship] =
    await Promise.all([
      databases().userDatabase.get(senderCognitoId),
      databases().userDatabase.get(recipientCognitoId),
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
  if (sender instanceof Failure) {
    return sender;
  } else if (recipient instanceof Failure) {
    return recipient;
  } else if (sender.gymId.toString() === recipient.gymId.toString()) {
    if (sentRequest instanceof Failure) {
      if (sentRequest === kFriendRequestNotFound) {
        if (friendship instanceof Failure) {
          if (friendship === kFriendshipNotFound) {
            if (receivedRequest instanceof Failure) {
              if (receivedRequest === kFriendRequestNotFound) {
                return {
                  ...(await databases().friendRequestDatabase.create(
                    senderCognitoId,
                    recipientCognitoId
                  )),
                  fromUser: {
                    cognitoId: senderCognitoId,
                    firstName: sender.firstName,
                    lastName: sender.lastName,
                    gymId: sender.gymId,
                    _id: sender._id,
                    confirmed: sender.confirmed,
                  },
                };
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
                return {
                  ...(await databases().friendshipDatabase.create([
                    senderCognitoId,
                    recipientCognitoId,
                  ])),
                  friend: {
                    cognitoId: senderCognitoId,
                    firstName: sender.firstName,
                    lastName: sender.lastName,
                    gymId: sender.gymId,
                    _id: sender._id,
                    confirmed: sender.confirmed,
                  },
                };
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
