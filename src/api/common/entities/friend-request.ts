import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsDynamo,
} from "./account";
import { Dynamo, DynamoShape } from "./dynamo";
import { UserExplore, kUserExploreDynamo, userExploreToDynamo } from "./user";

export type FriendRequest = CreationDetails & {
  userTuple: [UserExplore, UserExplore];
};

export const kFriendRequestDynamo: DynamoShape<FriendRequest> = {
  userTuple: [kUserExploreDynamo],
  ...kCreationDetailsDynamo,
};

export function friendRequestToDynamo(
  friendRequest: FriendRequest
): Dynamo<FriendRequest> {
  return {
    userTuple: {
      L: friendRequest.userTuple.map((user) => {
        return {
          M: userExploreToDynamo(user),
        };
      }),
    },
    ...creationDetailsToDynamo(friendRequest),
  };
}
