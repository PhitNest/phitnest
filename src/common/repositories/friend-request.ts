import {
  FriendRequest,
  UserExplore,
  friendRequestToDynamo,
  kFriendRequestParser,
} from "common/entities";
import { DynamoClient, RowKey } from "common/utils";
import * as uuid from "uuid";

const kFriendRequestPkPrefix = "USER#";
const kFriendRequestSkPrefix = "FRIEND_REQUEST#";

export function createFriendRequestKey(
  senderId: string,
  receiverId: string
): RowKey {
  return {
    pk: `${kFriendRequestPkPrefix}${senderId}`,
    sk: `${kFriendRequestSkPrefix}${receiverId}`,
  };
}

export async function createFriendRequest(
  dynamo: DynamoClient,
  sender: UserExplore,
  receiver: UserExplore
): Promise<FriendRequest> {
  const request: FriendRequest = {
    sender: sender,
    receiver: receiver,
    createdAt: new Date(),
    id: uuid.v4(),
  };
  await dynamo.put({
    ...createFriendRequestKey(sender.id, receiver.id),
    data: friendRequestToDynamo(request),
  });
  return request;
}

export async function getSentFriendRequests(
  dynamo: DynamoClient,
  userId: string
): Promise<FriendRequest[]> {
  return await dynamo.parsedQuery({
    pk: `${kFriendRequestPkPrefix}${userId}`,
    sk: { q: kFriendRequestSkPrefix, op: "BEGINS_WITH" },
    parseShape: kFriendRequestParser,
  });
}

export async function getReceivedFriendRequests(
  dynamo: DynamoClient,
  userId: string
): Promise<FriendRequest[]> {
  return await dynamo.parsedQuery({
    pk: `${kFriendRequestSkPrefix}${userId}`,
    sk: { q: kFriendRequestPkPrefix, op: "BEGINS_WITH" },
    table: "inverted",
    parseShape: kFriendRequestParser,
  });
}

export async function deleteFriendRequest(
  dynamo: DynamoClient,
  senderId: string,
  receiverId: string
) {
  await dynamo.delete(createFriendRequestKey(senderId, receiverId));
}
