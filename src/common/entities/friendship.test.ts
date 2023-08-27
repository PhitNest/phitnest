import { SerializedDynamo, parseDynamo } from "./dynamo";
import {
  Friendship,
  FriendshipWithoutMessage,
  friendshipToDynamo,
  friendshipWithoutMessageToDynamo,
  kFriendshipParser,
  kFriendshipWithoutMessageParser,
} from "./friendship";

const kTestFriendshipWithoutMessage: FriendshipWithoutMessage = {
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  id: "1",
  sender: {
    id: "1",
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    firstName: "John",
    lastName: "Doe",
    identityId: "1",
  },
  receiver: {
    id: "2",
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    firstName: "Jane",
    lastName: "Doe",
    identityId: "2",
  },
};

const kSerializedFriendshipWithoutMessage: SerializedDynamo<FriendshipWithoutMessage> =
  {
    createdAt: { N: Date.UTC(2020, 1, 1).toString() },
    id: { S: "1" },
    sender: {
      M: {
        id: { S: "1" },
        createdAt: { N: Date.UTC(2020, 1, 1).toString() },
        firstName: { S: "John" },
        lastName: { S: "Doe" },
        identityId: { S: "1" },
      },
    },
    receiver: {
      M: {
        id: { S: "2" },
        createdAt: { N: Date.UTC(2020, 1, 1).toString() },
        firstName: { S: "Jane" },
        lastName: { S: "Doe" },
        identityId: { S: "2" },
      },
    },
  };

const kTestFriendship: Friendship = {
  ...kTestFriendshipWithoutMessage,
  recentMessage: {
    id: "1",
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    text: "Hello",
    senderId: "1",
  },
};

const serializedFriendship: SerializedDynamo<Friendship> = {
  ...kSerializedFriendshipWithoutMessage,
  recentMessage: {
    M: {
      id: { S: "1" },
      createdAt: { N: Date.UTC(2020, 1, 1).toString() },
      text: { S: "Hello" },
      senderId: { S: "1" },
    },
  },
};

describe("FriendshipWithoutMessage", () => {
  it("serializes to dynamo", () => {
    expect(
      friendshipWithoutMessageToDynamo(kTestFriendshipWithoutMessage)
    ).toEqual(kSerializedFriendshipWithoutMessage);
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(
        kSerializedFriendshipWithoutMessage,
        kFriendshipWithoutMessageParser
      )
    ).toEqual(kTestFriendshipWithoutMessage);
  });
});

describe("Friendship", () => {
  it("serializes to dynamo", () => {
    expect(friendshipToDynamo(kTestFriendship)).toEqual(serializedFriendship);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedFriendship, kFriendshipParser)).toEqual(
      kTestFriendship
    );
  });
});
