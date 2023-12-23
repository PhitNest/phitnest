import { SerializedDynamo, DynamoParser } from "./dynamo";
import { Message, kMessageParser, messageToDynamo } from "./message";
import { UserExplore, kUserExploreParser, userExploreToDynamo } from "./user";

export type FriendRequest = {
  id: string;
  sender: UserExplore;
  receiver: UserExplore;
  createdAt: Date;
  __poly__: "FriendRequest";
};

export const kFriendRequestParser: DynamoParser<FriendRequest> = {
  id: "S",
  sender: kUserExploreParser,
  receiver: kUserExploreParser,
  createdAt: "D",
  __poly__: "S",
};

export type FriendWithoutMessage = Omit<FriendRequest, "__poly__"> & {
  acceptedAt: Date;
  __poly__: "FriendWithoutMessage";
};

export const kFriendWithoutMessageParser: DynamoParser<FriendWithoutMessage> = {
  ...kFriendRequestParser,
  acceptedAt: "D",
  __poly__: "S",
};

export type Friendship = Omit<FriendWithoutMessage, "__poly__"> & {
  recentMessage: Message;
  __poly__: "Friendship";
};

export const kFriendshipParser: DynamoParser<Friendship> = {
  ...kFriendWithoutMessageParser,
  recentMessage: kMessageParser,
  __poly__: "S",
};

export function friendRequestToDynamo(
  friendRequest: FriendRequest
): SerializedDynamo<FriendRequest> {
  return {
    id: { S: friendRequest.id },
    sender: {
      M: userExploreToDynamo(friendRequest.sender),
    },
    receiver: {
      M: userExploreToDynamo(friendRequest.receiver),
    },
    createdAt: { N: friendRequest.createdAt.getTime().toString() },
    __poly__: { S: "FriendRequest" },
  };
}

export function FriendWithoutMessageToDynamo(
  friendship: FriendWithoutMessage
): SerializedDynamo<FriendWithoutMessage> {
  return {
    ...friendRequestToDynamo({ ...friendship, __poly__: "FriendRequest" }),
    acceptedAt: { N: friendship.acceptedAt.getTime().toString() },
    __poly__: { S: "FriendWithoutMessage" },
  };
}

export function friendshipToDynamo(
  friendship: Friendship
): SerializedDynamo<Friendship> {
  return {
    ...FriendWithoutMessageToDynamo({
      ...friendship,
      __poly__: "FriendWithoutMessage",
    }),
    recentMessage: { M: messageToDynamo(friendship.recentMessage) },
    __poly__: { S: "Friendship" },
  };
}
