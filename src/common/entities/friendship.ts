import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsParser,
} from "./account";
import { SerializedDynamo, DynamoParser } from "./dynamo";
import { Message, kMessageParser, messageToDynamo } from "./message";
import { UserExplore, kUserExploreParser, userExploreToDynamo } from "./user";

export type FriendshipWithoutMessage = CreationDetails & {
  otherUser: UserExplore;
};

export const kFriendshipWithoutMessageParser: DynamoParser<FriendshipWithoutMessage> =
  {
    otherUser: kUserExploreParser,
    ...kCreationDetailsParser,
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
    otherUser: {
      M: userExploreToDynamo(friendship.otherUser),
    },
    ...creationDetailsToDynamo(friendship),
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
