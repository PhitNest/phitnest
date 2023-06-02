import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsDynamo,
} from "./account";
import { Dynamo, DynamoShape } from "./dynamo";
import { Message, kMessageDynamo, messageToDynamo } from "./message";
import { UserExplore, kUserExploreDynamo, userExploreToDynamo } from "./user";

export type Friendship = CreationDetails & {
  users: [UserExplore, UserExplore];
  recentMessage: Message;
};

export const kFriendshipDynamo: DynamoShape<Friendship> = {
  users: [kUserExploreDynamo],
  recentMessage: kMessageDynamo,
  ...kCreationDetailsDynamo,
};

export function friendshipToDynamo(friendship: Friendship): Dynamo<Friendship> {
  return {
    users: {
      L: friendship.users.map((user) => {
        return {
          M: userExploreToDynamo(user),
        };
      }),
    },
    recentMessage: { M: messageToDynamo(friendship.recentMessage) },
    ...creationDetailsToDynamo(friendship),
  };
}
