import { SerializedDynamo, parseDynamo } from "./dynamo";
import {
  FriendRequest,
  friendRequestToDynamo,
  kFriendRequestParser,
} from "./friend-request";

const kTestFriendRequest: FriendRequest = {
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

const kSerializedFriendRequest: SerializedDynamo<FriendRequest> = {
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

describe("FriendRequest", () => {
  it("serializes to dynamo", () => {
    expect(friendRequestToDynamo(kTestFriendRequest)).toEqual(
      kSerializedFriendRequest
    );
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(kSerializedFriendRequest, kFriendRequestParser)).toEqual(
      kTestFriendRequest
    );
  });
});
