import { Dynamo, parseDynamo } from "./dynamo";
import {
  FriendRequest,
  friendRequestToDynamo,
  kFriendRequestDynamo,
} from "./friend-request";

const testFriendRequest: FriendRequest = {
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
};

const serializedFriendRequest: Dynamo<FriendRequest> = {
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
};

describe("FriendRequest", () => {
  it("serializes to Dynamo", () => {
    expect(friendRequestToDynamo(testFriendRequest)).toEqual(
      serializedFriendRequest
    );
  });

  it("deserializes from Dynamo", () => {
    expect(parseDynamo(serializedFriendRequest, kFriendRequestDynamo)).toEqual(
      testFriendRequest
    );
  });
});
