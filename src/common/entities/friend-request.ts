import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsParser,
} from "./account";
import { SerializedDynamo, DynamoParser } from "./dynamo";
import { UserExplore, kUserExploreParser, userExploreToDynamo } from "./user";

export type IncomingFriendRequest = CreationDetails & {
  sender: UserExplore;
};

export type OutgoingFriendRequest = CreationDetails & {
  receiver: UserExplore;
};

export const kIncomingFriendRequestParser: DynamoParser<IncomingFriendRequest> =
  {
    sender: kUserExploreParser,
    ...kCreationDetailsParser,
  };

export const kOutgoingFriendRequestParser: DynamoParser<OutgoingFriendRequest> =
  {
    receiver: kUserExploreParser,
    ...kCreationDetailsParser,
  };

export function incomingFriendRequestToDynamo(
  friendRequest: IncomingFriendRequest
): SerializedDynamo<IncomingFriendRequest> {
  return {
    sender: { M: userExploreToDynamo(friendRequest.sender) },
    ...creationDetailsToDynamo(friendRequest),
  };
}

export function outgoingFriendRequestToDynamo(
  friendRequest: OutgoingFriendRequest
): SerializedDynamo<OutgoingFriendRequest> {
  return {
    receiver: { M: userExploreToDynamo(friendRequest.receiver) },
    ...creationDetailsToDynamo(friendRequest),
  };
}
