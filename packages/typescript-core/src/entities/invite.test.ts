import { SerializedDynamo, parseDynamo } from "./dynamo";
import {
  Invite,
  UserInvite,
  inviteToDynamo,
  kInviteParser,
  userInviteToDynamo,
} from "./invite";

const kTestInvite: Invite = {
  __poly__: "Invite",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  receiverEmail: "something",
  gymId: "1",
};

const kSerializedInvite: SerializedDynamo<Invite> = {
  __poly__: { S: "Invite" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  receiverEmail: { S: "something" },
  gymId: { S: "1" },
};

const kTestUserInvite: UserInvite = {
  ...kTestInvite,
  __poly__: "UserInvite",
  senderId: "2",
};

const kSerializedUserInvite: SerializedDynamo<UserInvite> = {
  ...kSerializedInvite,
  __poly__: { S: "UserInvite" },
  senderId: { S: "2" },
};

describe("Invite", () => {
  it("serializes to dynamo", () => {
    expect(inviteToDynamo(kTestInvite)).toEqual(kSerializedInvite);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(kSerializedInvite, kInviteParser)).toEqual(kTestInvite);
  });
});

describe("UserInvite", () => {
  it("serializes to dynamo", () => {
    expect(userInviteToDynamo(kTestUserInvite)).toEqual(kSerializedUserInvite);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(kSerializedUserInvite, kInviteParser)).toEqual(
      kTestUserInvite,
    );
  });
});
