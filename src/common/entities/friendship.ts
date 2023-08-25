import { SerializedDynamo, DynamoParser } from "./dynamo";
import { Message, kMessageParser, messageToDynamo } from "./message";
import { UserExplore, kUserExploreParser, userExploreToDynamo } from "./user";

export type FriendshipWithoutMessage = {
  id: string;
  otherUser: UserExplore;
  createdAt: Date;
};

export const kFriendshipWithoutMessageParser: DynamoParser<FriendshipWithoutMessage> =
  {
    id: "S",
    otherUser: kUserExploreParser,
    createdAt: "D",
  };

export type Friendship = FriendshipWithoutMessage & {
  recentMessage: Message;
};

export const kFriendshipParser: DynamoParser<Friendship> = {
  recentMessage: kMessageParser,
  ...kFriendshipWithoutMessageParser,
};

export function friendshipWithoutMessageToDynamo(
  friendship: FriendshipWithoutMessage
): SerializedDynamo<FriendshipWithoutMessage> {
  return {
    id: { S: friendship.id },
    otherUser: {
      M: userExploreToDynamo(friendship.otherUser),
    },
    createdAt: { N: friendship.createdAt.getTime().toString() },
  };
}

export function friendshipToDynamo(
  friendship: Friendship
): SerializedDynamo<Friendship> {
  return {
    recentMessage: { M: messageToDynamo(friendship.recentMessage) },
    ...friendshipWithoutMessageToDynamo(friendship),
  };
}
