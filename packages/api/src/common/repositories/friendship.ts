import { AttributeValue } from "@aws-sdk/client-dynamodb";
import {
  FriendRequest,
  Friendship,
  FriendshipWithoutMessage,
  UserExplore,
  friendRequestToDynamo,
  friendshipWithoutMessageToDynamo,
  kFriendRequestParser,
  kFriendshipParser,
  kFriendshipWithoutMessageParser,
  parseDynamo,
} from "common/entities";
import {
  DynamoClient,
  RequestError,
  ResourceNotFoundError,
  RowKey,
} from "common/utils";
import * as uuid from "uuid";

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
  receiverId: string,
): RowKey {
  return {
    pk: friendshipSk(receiverId),
    sk: friendshipPk(senderId),
  };
}

function polymorphicParseFriendship(
  data: Record<string, AttributeValue>,
): FriendRequest | FriendshipWithoutMessage | Friendship {
  switch (data.__poly__.S) {
    case "FriendRequest":
      return parseDynamo(data, kFriendRequestParser);
    case "FriendshipWithoutMessage":
      return parseDynamo(data, kFriendshipWithoutMessageParser);
    case "Friendship":
      return parseDynamo(data, kFriendshipParser);
    default:
      throw new RequestError(
        "InvalidFriendshipType",
        "Invalid friendship type",
      );
  }
}

const kNoFriendshipFound = new RequestError(
  "NoFriendshipFound",
  "No friendship found between users",
);

export async function getFriendship(
  dynamo: DynamoClient,
  userId: string,
  friendId: string,
): Promise<
  FriendRequest | FriendshipWithoutMessage | Friendship | RequestError
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
      (friendship) => !(friendship instanceof ResourceNotFoundError),
    );
    if (friendship) {
      if (friendship instanceof ResourceNotFoundError) {
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
  userId: string,
): Promise<
  (FriendRequest | FriendshipWithoutMessage | Friendship)[] | RequestError
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

export async function createFriendRequest(
  dynamo: DynamoClient,
  sender: UserExplore,
  receiver: UserExplore,
): Promise<FriendRequest> {
  const friendRequest: FriendRequest = {
    id: uuid.v4(),
    sender: sender,
    receiver: receiver,
    createdAt: new Date(),
    __poly__: "FriendRequest",
  };
  await dynamo.put({
    ...friendshipKey(sender.id, receiver.id),
    data: friendRequestToDynamo(friendRequest),
  });
  return friendRequest;
}

export async function createFriendship(
  dynamo: DynamoClient,
  friendRequest: FriendRequest,
): Promise<FriendshipWithoutMessage> {
  const friendship: FriendshipWithoutMessage = {
    ...friendRequest,
    acceptedAt: new Date(),
    __poly__: "FriendshipWithoutMessage",
  };
  await dynamo.writeTransaction({
    puts: [
      {
        ...friendshipKey(friendship.sender.id, friendship.receiver.id),
        data: friendshipWithoutMessageToDynamo(friendship),
      },
    ],
  });
  return friendship;
}

export async function deleteFriendship(
  dynamo: DynamoClient,
  senderId: string,
  receiverId: string,
) {
  await dynamo.delete(friendshipKey(senderId, receiverId));
}
