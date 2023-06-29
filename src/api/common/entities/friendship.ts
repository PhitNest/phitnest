import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsDynamo,
} from "./account";
import { Dynamo, DynamoShape } from "./dynamo";
import { Message, kMessageDynamo, messageToDynamo } from "./message";
import { UserExplore, kUserExploreDynamo, userExploreToDynamo } from "./user";

export type FriendshipWithoutMessage = CreationDetails & {
  users: [UserExplore, UserExplore];
};

export const kFriendshipWithoutMessageDynamo: DynamoShape<FriendshipWithoutMessage> =
  {
    users: [kUserExploreDynamo],
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
    users: {
      L: friendship.users.map((user) => {
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
