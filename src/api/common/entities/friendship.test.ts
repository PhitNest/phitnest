import { Dynamo, parseDynamo } from "./dynamo";
import {
  Friendship,
  friendshipToDynamo,
  kFriendshipDynamo,
} from "./friendship";

const testFriendship: Friendship = {
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  id: "1",
  userTuple: [
    {
      accountDetails: {
        id: "1",
        createdAt: new Date(Date.UTC(2020, 1, 1)),
      },
      firstName: "John",
      lastName: "Doe",
    },
    {
      accountDetails: {
        id: "2",
        createdAt: new Date(Date.UTC(2020, 1, 1)),
      },
      firstName: "Jane",
      lastName: "Doe",
    },
  ],
  recentMessage: {
    id: "1",
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    text: "Hello",
    senderId: "1",
  },
};

const serializedFriendship: Dynamo<Friendship> = {
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  id: { S: "1" },
  userTuple: {
    L: [
      {
        M: {
          accountDetails: {
            M: {
              id: { S: "1" },
              createdAt: { N: Date.UTC(2020, 1, 1).toString() },
            },
          },
          firstName: { S: "John" },
          lastName: { S: "Doe" },
        },
      },
      {
        M: {
          accountDetails: {
            M: {
              id: { S: "2" },
              createdAt: { N: Date.UTC(2020, 1, 1).toString() },
            },
          },
          firstName: { S: "Jane" },
          lastName: { S: "Doe" },
        },
      },
    ],
  },
  recentMessage: {
    M: {
      id: { S: "1" },
      createdAt: { N: Date.UTC(2020, 1, 1).toString() },
      text: { S: "Hello" },
      senderId: { S: "1" },
    },
  },
};

describe("Friendship", () => {
  it("serializes to Dynamo", () => {
    expect(friendshipToDynamo(testFriendship)).toEqual(serializedFriendship);
  });

  it("deserializes from Dynamo", () => {
    expect(parseDynamo(serializedFriendship, kFriendshipDynamo)).toEqual(
      testFriendship
    );
  });
});
