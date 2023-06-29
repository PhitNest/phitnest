import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsDynamo,
} from "./account";
import { Dynamo, DynamoShape } from "./dynamo";
import { UserExplore, kUserExploreDynamo, userExploreToDynamo } from "./user";

export type FriendRequest = CreationDetails & {
  users: [UserExplore, UserExplore];
};

export const kFriendRequestDynamo: DynamoShape<FriendRequest> = {
  users: [kUserExploreDynamo],
  ...kCreationDetailsDynamo,
};

export function friendRequestToDynamo(
  friendRequest: FriendRequest
): Dynamo<FriendRequest> {
  return {
    users: {
      L: friendRequest.users.map((user) => {
        return {
          M: userExploreToDynamo(user),
        };
      }),
    },
    ...creationDetailsToDynamo(friendRequest),
  };
}
