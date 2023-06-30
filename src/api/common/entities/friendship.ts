import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsDynamo,
} from "./account";
import { Dynamo, DynamoShape } from "./dynamo";
import { Message, kMessageDynamo, messageToDynamo } from "./message";
import { UserExplore, kUserExploreDynamo, userExploreToDynamo } from "./user";

export type FriendshipWithoutMessage = CreationDetails & {
  userTuple: [UserExplore, UserExplore];
};

export const kFriendshipWithoutMessageDynamo: DynamoShape<FriendshipWithoutMessage> =
  {
    userTuple: [kUserExploreDynamo],
    ...kCreationDetailsDynamo,
  };

export type Friendship = FriendshipWithoutMessage & {
  recentMessage: Message;
};

export const kFriendshipDynamo: DynamoShape<Friendship> = {
  recentMessage: kMessageDynamo,
  ...kFriendshipWithoutMessageDynamo,
};

export function friendshipWithoutMessageToDynamo(
  friendship: FriendshipWithoutMessage
): Dynamo<FriendshipWithoutMessage> {
  return {
    userTuple: {
      L: friendship.userTuple.map((user) => {
        return {
          M: userExploreToDynamo(user),
        };
      }),
    },
    ...creationDetailsToDynamo(friendship),
  };
}

export function friendshipToDynamo(friendship: Friendship): Dynamo<Friendship> {
  return {
    recentMessage: { M: messageToDynamo(friendship.recentMessage) },
    ...friendshipWithoutMessageToDynamo(friendship),
  };
}
