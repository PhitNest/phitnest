import {
  Friendship,
  FriendshipWithoutMessage,
  friendshipWithoutMessageToDynamo,
  kFriendshipParser,
  kFriendshipWithoutMessageParser,
  parseDynamo,
} from "common/entities";
import {
  DynamoClient,
  PutParams,
  RequestError,
  ResourceNotFoundError,
} from "common/utils";

const kFriendshipPkPrefix = "USER#";
const kFriendshipSkPrefix = "FRIENDSHIP#";

export function createFriendshipParams(
  friendship: FriendshipWithoutMessage
): PutParams {
  return {
    pk: `${kFriendshipPkPrefix}${friendship.sender.id}`,
    sk: `${kFriendshipSkPrefix}${friendship.receiver.id}`,
    data: friendshipWithoutMessageToDynamo(friendship),
  };
}

export async function getFriendship(
  dynamo: DynamoClient,
  userId: string,
  friendId: string
): Promise<FriendshipWithoutMessage | RequestError> {
  const friendships = (
    await Promise.all([
      dynamo.parsedQuery({
        pk: `${kFriendshipPkPrefix}${userId}`,
        sk: { q: `${kFriendshipSkPrefix}${friendId}`, op: "EQ" },
        parseShape: kFriendshipWithoutMessageParser,
      }),
      dynamo.parsedQuery({
        pk: `${kFriendshipPkPrefix}${friendId}`,
        sk: { q: `${kFriendshipSkPrefix}${userId}`, op: "EQ" },
        parseShape: kFriendshipWithoutMessageParser,
      }),
    ])
  ).flat();
  if (friendships.length === 0) {
    return new RequestError(
      "NoFriendshipFound",
      "No friendship found between users"
    );
  } else {
    const friendship = friendships.find(
      (friendship) => !(friendship instanceof ResourceNotFoundError)
    );
    return friendship ?? friendships[0];
  }
}

export async function getFriendships(
  dynamo: DynamoClient,
  userId: string
): Promise<FriendshipWithoutMessage[]> {
  return (
    await Promise.all([
      dynamo.parsedQuery({
        pk: `${kFriendshipPkPrefix}${userId}`,
        sk: { q: kFriendshipSkPrefix, op: "BEGINS_WITH" },
        parseShape: kFriendshipWithoutMessageParser,
      }),
      dynamo.parsedQuery({
        pk: `${kFriendshipSkPrefix}${userId}`,
        sk: { q: kFriendshipPkPrefix, op: "BEGINS_WITH" },
        table: "inverted",
        parseShape: kFriendshipWithoutMessageParser,
      }),
    ])
  ).flat();
}

export async function getFriendshipsWithMessages(
  dynamo: DynamoClient,
  userId: string
): Promise<(FriendshipWithoutMessage | Friendship)[]> {
  const friendshipsRaw = (
    await Promise.all([
      dynamo.query({
        pk: `${kFriendshipPkPrefix}${userId}`,
        sk: { q: kFriendshipSkPrefix, op: "BEGINS_WITH" },
      }),
      dynamo.query({
        pk: `${kFriendshipSkPrefix}${userId}`,
        sk: { q: kFriendshipPkPrefix, op: "BEGINS_WITH" },
        table: "inverted",
      }),
    ])
  ).flat();
  return friendshipsRaw.map((friendship) => {
    if (friendship.recentMessage) {
      return parseDynamo(friendship, kFriendshipParser);
    } else {
      return parseDynamo(friendship, kFriendshipWithoutMessageParser);
    }
  });
}

export async function deleteFriendship(
  dynamo: DynamoClient,
  senderId: string,
  receiverId: string
) {
  await dynamo.delete({
    pk: `${kFriendshipPkPrefix}${senderId}`,
    sk: `${kFriendshipSkPrefix}${receiverId}`,
  });
}
