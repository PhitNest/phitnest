import { SerializedDynamo, parseDynamo } from "./dynamo";
import { InviteWithoutSender } from "./invite";
import {
  UserInvitedByAdmin,
  UserInvitedByUser,
  UserWithoutInvite,
  kUserInvitedByAdminParser,
  kUserInvitedByUserParser,
  userInvitedByAdminToDynamo,
  userInvitedByUserToDynamo,
} from "./user";

const testUserWithoutInvite: UserWithoutInvite = {
  id: "test",
  email: "test",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  firstName: "test",
  lastName: "test",
  numInvites: 1,
  identityId: "test",
};

const serializedUserWithoutInvite: SerializedDynamo<UserWithoutInvite> = {
  id: { S: "test" },
  email: { S: "test" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  firstName: { S: "test" },
  lastName: { S: "test" },
  numInvites: { N: "1" },
  identityId: { S: "test" },
};

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

const serializedInviteWithoutSender: SerializedDynamo<InviteWithoutSender> = {
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

const testUserInvitedByUser: UserInvitedByUser = {
  ...testUserWithoutInvite,
  invite: {
    ...testInviteWithoutSender,
    type: "user",
    inviter: testUserWithoutInvite,
  },
};

const serializedUserInvitedByUser: SerializedDynamo<UserInvitedByUser> = {
  ...serializedUserWithoutInvite,
  invite: {
    M: {
      ...serializedInviteWithoutSender,
      type: { S: "user" },
      inviter: { M: serializedUserWithoutInvite },
    },
  },
};

const testUserInvitedByAdmin: UserInvitedByAdmin = {
  ...testUserWithoutInvite,
  invite: {
    ...testInviteWithoutSender,
    type: "admin",
    inviter: {
      email: "test",
      id: "test",
    },
  },
};

const serializedUserInvitedByAdmin: SerializedDynamo<UserInvitedByAdmin> = {
  ...serializedUserWithoutInvite,
  invite: {
    M: {
      ...serializedInviteWithoutSender,
      type: { S: "admin" },
      inviter: {
        M: {
          email: { S: "test" },
          id: { S: "test" },
        },
      },
    },
  },
};

describe("User invited by user", () => {
  it("serializes to dynamo", () => {
    expect(userInvitedByUserToDynamo(testUserInvitedByUser)).toEqual(
      serializedUserInvitedByUser
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(serializedUserInvitedByUser, kUserInvitedByUserParser)
    ).toEqual(testUserInvitedByUser);
  });
});

describe("User invited by admin", () => {
  it("serializes to dynamo", () => {
    expect(userInvitedByAdminToDynamo(testUserInvitedByAdmin)).toEqual(
      serializedUserInvitedByAdmin
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(serializedUserInvitedByAdmin, kUserInvitedByAdminParser)
    ).toEqual(testUserInvitedByAdmin);
  });
});
