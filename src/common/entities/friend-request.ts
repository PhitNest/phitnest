import { SerializedDynamo, DynamoParser } from "./dynamo";
import { UserExplore, kUserExploreParser, userExploreToDynamo } from "./user";

export type FriendRequest = {
  id: string;
  sender: UserExplore;
  receiver: UserExplore;
  createdAt: Date;
};

export const kFriendRequestParser: DynamoParser<FriendRequest> = {
  id: "S",
  receiver: kUserExploreParser,
  sender: kUserExploreParser,
  createdAt: "D",
};

export function friendRequestToDynamo(
  friendRequest: FriendRequest
): SerializedDynamo<FriendRequest> {
  return {
    id: { S: friendRequest.id },
    receiver: { M: userExploreToDynamo(friendRequest.receiver) },
    sender: { M: userExploreToDynamo(friendRequest.sender) },
    createdAt: { N: friendRequest.createdAt.getTime().toString() },
  };
}
