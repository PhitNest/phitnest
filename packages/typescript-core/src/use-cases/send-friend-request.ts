import { FriendRequest, FriendshipWithoutMessage } from "../entities";
import {
  createFriendRequest,
  createFriendship,
  getFriendship,
  getUserExplore,
} from "../repositories";
import {
  DynamoClient,
  RequestError,
  ResourceNotFoundError,
} from "../utils";

export async function sendFriendRequest(
  dynamo: DynamoClient,
  senderId: string,
  receiverId: string,
): Promise<FriendRequest | FriendshipWithoutMessage | RequestError> {
  const [friendship, sender, receiver] = await Promise.all([
    getFriendship(dynamo, senderId, receiverId),
    getUserExplore(dynamo, senderId),
    getUserExplore(dynamo, receiverId),
  ]);
  if (receiver instanceof ResourceNotFoundError) {
    return receiver;
  } else if (sender instanceof ResourceNotFoundError) {
    return sender;
  } else if (friendship instanceof RequestError) {
    const request = await createFriendRequest(dynamo, sender, receiver);
    return request;
  } else {
    switch (friendship.__poly__) {
      case "FriendRequest":
        if (friendship.sender.id === senderId) {
          return new RequestError(
            "FriendRequestExists",
            "Outgoing friend request already exists",
          );
        } else {
          return await createFriendship(dynamo, friendship);
        }
      default:
        return new RequestError(
          "FriendshipExists",
          "Friendship already exists",
        );
    }
  }
}
