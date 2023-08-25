import { SerializedDynamo, DynamoParser } from "./dynamo";
import { UserExplore, kUserExploreParser, userExploreToDynamo } from "./user";

export type IncomingFriendRequest = {
  id: string;
  sender: UserExplore;
  createdAt: Date;
};

export type OutgoingFriendRequest = {
  id: string;
  receiver: UserExplore;
  createdAt: Date;
};

export const kIncomingFriendRequestParser: DynamoParser<IncomingFriendRequest> =
  {
    id: "S",
    sender: kUserExploreParser,
    createdAt: "D",
  };

export const kOutgoingFriendRequestParser: DynamoParser<OutgoingFriendRequest> =
  {
    id: "S",
    receiver: kUserExploreParser,
    createdAt: "D",
  };

export function incomingFriendRequestToDynamo(
  friendRequest: IncomingFriendRequest
): SerializedDynamo<IncomingFriendRequest> {
  return {
    id: { S: friendRequest.id },
    sender: { M: userExploreToDynamo(friendRequest.sender) },
    createdAt: { N: friendRequest.createdAt.getTime().toString() },
  };
}

export function outgoingFriendRequestToDynamo(
  friendRequest: OutgoingFriendRequest
): SerializedDynamo<OutgoingFriendRequest> {
  return {
    id: { S: friendRequest.id },
    receiver: { M: userExploreToDynamo(friendRequest.receiver) },
    createdAt: { N: friendRequest.createdAt.getTime().toString() },
  };
}
