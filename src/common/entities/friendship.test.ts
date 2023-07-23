import { SerializedDynamo, parseDynamo } from "./dynamo";
import {
  Friendship,
  FriendshipWithoutMessage,
  friendshipToDynamo,
  friendshipWithoutMessageToDynamo,
  kFriendshipParser,
  kFriendshipWithoutMessageParser,
} from "./friendship";

const testFriendshipWithoutMessage: FriendshipWithoutMessage = {
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  id: "1",
  otherUser: {
    id: "2",
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    firstName: "Jane",
    lastName: "Doe",
    identityId: "test2",
  },
};

const serializedFriendshipWithoutMessage: SerializedDynamo<FriendshipWithoutMessage> =
  {
    createdAt: { N: Date.UTC(2020, 1, 1).toString() },
    id: { S: "1" },
    otherUser: {
      M: {
        id: { S: "2" },
        createdAt: { N: Date.UTC(2020, 1, 1).toString() },
        firstName: { S: "Jane" },
        lastName: { S: "Doe" },
        identityId: { S: "test2" },
      },
    },
  };

const testFriendship: Friendship = {
  ...testFriendshipWithoutMessage,
  recentMessage: {
    id: "1",
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    text: "Hello",
    senderId: "1",
  },
};

const serializedFriendship: SerializedDynamo<Friendship> = {
  ...serializedFriendshipWithoutMessage,
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
      friendshipWithoutMessageToDynamo(testFriendshipWithoutMessage)
    ).toEqual(serializedFriendshipWithoutMessage);
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(
        serializedFriendshipWithoutMessage,
        kFriendshipWithoutMessageParser
      )
    ).toEqual(testFriendshipWithoutMessage);
  });
});

describe("Friendship", () => {
  it("serializes to dynamo", () => {
    expect(friendshipToDynamo(testFriendship)).toEqual(serializedFriendship);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedFriendship, kFriendshipParser)).toEqual(
      testFriendship
    );
  });
});
