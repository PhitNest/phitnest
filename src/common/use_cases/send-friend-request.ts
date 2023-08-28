import { FriendRequest, FriendshipWithoutMessage } from "common/entities";
import {
  createFriendRequest,
  createFriendRequestKey,
  createFriendshipParams,
  getFriendship,
  getReceivedFriendRequests,
  getSentFriendRequests,
  getUserExplore,
} from "common/repositories";
import {
  DynamoClient,
  RequestError,
  ResourceNotFoundError,
} from "common/utils";
import * as uuid from "uuid";

export async function sendFriendRequest(
  dynamo: DynamoClient,
  senderId: string,
  receiverId: string
): Promise<FriendRequest | FriendshipWithoutMessage | RequestError> {
  const [receivedRequest, sentRequest, friendship, sender, receiver] =
    await Promise.all([
      getReceivedFriendRequests(dynamo, senderId),
      getSentFriendRequests(dynamo, senderId),
      getFriendship(dynamo, senderId, receiverId),
      getUserExplore(dynamo, senderId),
      getUserExplore(dynamo, receiverId),
    ]);
  if (receiver instanceof ResourceNotFoundError) {
    return receiver;
  } else if (sender instanceof ResourceNotFoundError) {
    return sender;
  } else if (friendship instanceof ResourceNotFoundError) {
    if (sentRequest instanceof ResourceNotFoundError) {
      if (receivedRequest instanceof ResourceNotFoundError) {
        const request = await createFriendRequest(dynamo, sender, receiver);
        return request;
      } else {
        const friendshipCreatedAt = new Date();
        const friendshipId = uuid.v4();
        const friendship: FriendshipWithoutMessage = {
          receiver: sender,
          sender: receiver,
          createdAt: friendshipCreatedAt,
          id: friendshipId,
        };
        await dynamo.writeTransaction({
          deletes: [createFriendRequestKey(sender.id, receiver.id)],
          puts: [createFriendshipParams(friendship)],
        });
        return friendship;
      }
    } else {
      return new RequestError(
        "FriendRequestExists",
        "Outgoing friend request already exists"
      );
    }
  } else {
    return new RequestError("FriendshipExists", "Friendship already exists");
  }
}
