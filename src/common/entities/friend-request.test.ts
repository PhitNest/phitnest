import { SerializedDynamo, parseDynamo } from "./dynamo";
import {
  IncomingFriendRequest,
  incomingFriendRequestToDynamo,
  kIncomingFriendRequestParser,
  OutgoingFriendRequest,
  outgoingFriendRequestToDynamo,
  kOutgoingFriendRequestParser,
} from "./friend-request";

const testIncomingFriendRequest: IncomingFriendRequest = {
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  id: "1",
  sender: {
    id: "1",
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    firstName: "John",
    lastName: "Doe",
    identityId: "1",
  },
};

const testOutgoingFriendRequest: OutgoingFriendRequest = {
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  id: "1",
  receiver: {
    id: "2",
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    firstName: "Jane",
    lastName: "Doe",
    identityId: "2",
  },
};

const serializedIncomingFriendRequest: SerializedDynamo<IncomingFriendRequest> =
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
  };

const serializedOutgoingFriendRequest: SerializedDynamo<OutgoingFriendRequest> =
  {
    createdAt: { N: Date.UTC(2020, 1, 1).toString() },
    id: { S: "1" },
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

describe("IncomingFriendRequest", () => {
  it("serializes to dynamo", () => {
    expect(incomingFriendRequestToDynamo(testIncomingFriendRequest)).toEqual(
      serializedIncomingFriendRequest
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(serializedIncomingFriendRequest, kIncomingFriendRequestParser)
    ).toEqual(testIncomingFriendRequest);
  });
});

describe("OutgoingFriendRequest", () => {
  it("serializes to dynamo", () => {
    expect(outgoingFriendRequestToDynamo(testOutgoingFriendRequest)).toEqual(
      serializedOutgoingFriendRequest
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(serializedOutgoingFriendRequest, kOutgoingFriendRequestParser)
    ).toEqual(testOutgoingFriendRequest);
  });
});
