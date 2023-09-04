import { SerializedDynamo, parseDynamo } from "./dynamo";
import { Invite, inviteToDynamo, kInviteParser } from "./invite";

const kTestInvite: Invite = {
  senderType: "user",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  receiverEmail: "something",
  senderId: "1",
  gymId: "1",
};

const kSerializedInvite: SerializedDynamo<Invite> = {
  senderType: { S: "user" },
  senderId: { S: "1" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  receiverEmail: { S: "something" },
  gymId: { S: "1" },
};

describe("Invite", () => {
  it("serializes to dynamo", () => {
    expect(inviteToDynamo(kTestInvite)).toEqual(kSerializedInvite);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(kSerializedInvite, kInviteParser)).toEqual(kTestInvite);
  });
});
