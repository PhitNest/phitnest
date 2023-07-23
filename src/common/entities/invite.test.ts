import { SerializedDynamo, parseDynamo } from "./dynamo";
import {
  AdminInvite,
  InviteWithoutSender,
  UserInvite,
  adminInviteToDynamo,
  kAdminInviteParser,
  kUserInviteParser,
  userInviteToDynamo,
} from "./invite";

const testInviteWithoutSender: InviteWithoutSender = {
  type: "user",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  receiverEmail: "something",
  gym: {
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    id: "1",
    gymName: "something",
    address: {
      street: "street",
      city: "city",
      state: "state",
      zipCode: "zipCode",
    },
    gymLocation: {
      longitude: 1,
      latitude: 2,
    },
  },
};

const serializedInviteWithoutUser: SerializedDynamo<InviteWithoutSender> = {
  type: { S: "user" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  receiverEmail: { S: "something" },
  gym: {
    M: {
      createdAt: { N: Date.UTC(2020, 1, 1).toString() },
      id: { S: "1" },
      gymName: { S: "something" },
      address: {
        M: {
          street: { S: "street" },
          city: { S: "city" },
          state: { S: "state" },
          zipCode: { S: "zipCode" },
        },
      },
      gymLocation: {
        M: {
          longitude: { N: "1" },
          latitude: { N: "2" },
        },
      },
    },
  },
};

const testUserInvite: UserInvite = {
  ...testInviteWithoutSender,
  type: "user",
  inviter: {
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    id: "1",
    email: "something",
    firstName: "something",
    lastName: "something",
    numInvites: 5,
    identityId: "test",
  },
};

const serializedUserInvite: SerializedDynamo<UserInvite> = {
  ...serializedInviteWithoutUser,
  type: { S: "user" },
  inviter: {
    M: {
      createdAt: { N: Date.UTC(2020, 1, 1).toString() },
      id: { S: "1" },
      email: { S: "something" },
      firstName: { S: "something" },
      lastName: { S: "something" },
      numInvites: { N: "5" },
      identityId: { S: "test" },
    },
  },
};

const testAdminInvite: AdminInvite = {
  ...testInviteWithoutSender,
  type: "admin",
  inviter: {
    email: "something",
    id: "1",
  },
};

const serializedAdminInvite: SerializedDynamo<AdminInvite> = {
  ...serializedInviteWithoutUser,
  type: { S: "admin" },
  inviter: {
    M: {
      email: { S: "something" },
      id: { S: "1" },
    },
  },
};

describe("Invite from admin", () => {
  it("serializes to dynamo", () => {
    expect(adminInviteToDynamo(testAdminInvite)).toEqual(serializedAdminInvite);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedAdminInvite, kAdminInviteParser)).toEqual(
      testAdminInvite
    );
  });
});

describe("Invite from user", () => {
  it("serializes to dynamo", () => {
    expect(userInviteToDynamo(testUserInvite)).toEqual(serializedUserInvite);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedUserInvite, kUserInviteParser)).toEqual(
      testUserInvite
    );
  });
});
