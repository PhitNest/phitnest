import { AttributeValue } from "@aws-sdk/client-dynamodb";
import {
  FriendRequest,
  Friendship,
  FriendWithoutMessage,
  FriendWithoutMessageToDynamo,
  kFriendRequestParser,
  kFriendshipParser,
  kFriendWithoutMessageParser,
  parseDynamo,
} from "../entities";
import {
  DynamoClient,
  isResourceNotFound,
  requestError,
  ResourceNotFound,
  RowKey,
} from "../utils";

const kFriendshipPkPrefix = "USER#";
const kFriendshipSkPrefix = "FRIENDSHIP#";

export function friendshipPk(id: string) {
  return `${kFriendshipPkPrefix}${id}`;
}

export function friendshipSk(id: string) {
  return `${kFriendshipSkPrefix}${id}`;
}

export function friendshipKey(senderId: string, receiverId: string): RowKey {
  return {
    pk: friendshipPk(senderId),
    sk: friendshipSk(receiverId),
  };
}

export function friendshipInvertedKey(
  senderId: string,
  receiverId: string
): RowKey {
  return {
    pk: friendshipSk(receiverId),
    sk: friendshipPk(senderId),
  };
}

function polymorphicParseFriendship(
  data: Record<string, AttributeValue>
): FriendRequest | FriendWithoutMessage | Friendship {
  switch (data.__poly__.S) {
    case "FriendRequest":
      return parseDynamo(data, kFriendRequestParser);
    case "FriendWithoutMessage":
      return parseDynamo(data, kFriendWithoutMessageParser);
    case "Friendship":
      return parseDynamo(data, kFriendshipParser);
    default:
      throw requestError("InvalidFriendshipType", "Invalid friendship type");
  }
}

const kNoFriendshipFound = requestError(
  "NoFriendshipFound",
  "No friendship found between users"
);

export async function getFriendship(
  dynamo: DynamoClient,
  userId: string,
  friendId: string
): Promise<
  | FriendRequest
  | FriendWithoutMessage
  | Friendship
  | typeof kNoFriendshipFound
  | ResourceNotFound
> {
  const friendships = (
    await Promise.all([
      dynamo.query({
        pk: friendshipPk(userId),
        sk: { q: friendshipSk(friendId), op: "EQ" },
      }),
      dynamo.query({
        pk: friendshipPk(friendId),
        sk: { q: friendshipSk(userId), op: "EQ" },
      }),
    ])
  ).flat();
  if (friendships.length === 0) {
    return kNoFriendshipFound;
  } else {
    const friendship = friendships.find(
      (friendship) => !isResourceNotFound(friendship)
    );
    if (friendship) {
      if (isResourceNotFound(friendship)) {
        return friendship;
      }
      return polymorphicParseFriendship(friendship);
    } else {
      return kNoFriendshipFound;
    }
  }
}

export async function getFriendships(
  dynamo: DynamoClient,
  userId: string
): Promise<
  (FriendRequest | FriendWithoutMessage | Friendship)[] | ResourceNotFound
> {
  return (
    await Promise.all([
      dynamo.query({
        pk: friendshipPk(userId),
        sk: { q: kFriendshipSkPrefix, op: "BEGINS_WITH" },
      }),
      dynamo.query({
        pk: friendshipSk(userId),
        sk: { q: kFriendshipPkPrefix, op: "BEGINS_WITH" },
        table: "inverted",
      }),
    ])
  )
    .flat()
    .map(polymorphicParseFriendship);
}

export async function createFriendship(
  dynamo: DynamoClient,
  friendRequest: FriendRequest
): Promise<FriendWithoutMessage> {
  const friendship: FriendWithoutMessage = {
    ...friendRequest,
    acceptedAt: new Date(),
    __poly__: "FriendWithoutMessage",
  };
  await dynamo.writeTransaction({
    puts: [
      {
        ...friendshipKey(friendship.sender.id, friendship.receiver.id),
        data: FriendWithoutMessageToDynamo(friendship),
      },
    ],
  });
  return friendship;
}

export async function deleteFriendship(
  dynamo: DynamoClient,
  senderId: string,
  receiverId: string
) {
  await dynamo.delete(friendshipKey(senderId, receiverId));
}
