import { Dynamo, parseDynamo } from "./dynamo";
import { AdminEmail, InviteWithoutUser } from "./invite";
import {
  UserWithoutInvite,
  User,
  kUserInvitedByAdminDynamo,
  kUserInvitedByUserDynamo,
  userInvitedByAdminToDynamo,
  userInvitedByUserToDynamo,
} from "./user";

const testUserWithoutInvite: UserWithoutInvite = {
  accountDetails: {
    id: "test",
    email: "test",
    createdAt: new Date(Date.UTC(2020, 1, 1)),
  },
  firstName: "test",
  lastName: "test",
  numInvites: 1,
};

const serializedUserWithoutInvite: Dynamo<UserWithoutInvite> = {
  accountDetails: {
    M: {
      id: { S: "test" },
      email: { S: "test" },
      createdAt: { N: Date.UTC(2020, 1, 1).toString() },
    },
  },
  firstName: { S: "test" },
  lastName: { S: "test" },
  numInvites: { N: "1" },
};

const testInviteWithoutUser: InviteWithoutUser = {
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
    location: {
      longitude: 1,
      latitude: 2,
    },
  },
};

const serializedInviteWithoutUser: Dynamo<InviteWithoutUser> = {
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
      location: {
        M: {
          longitude: { N: "1" },
          latitude: { N: "2" },
        },
      },
    },
  },
};

const testUserInvitedByUser: User<UserWithoutInvite> = {
  ...testUserWithoutInvite,
  invite: {
    ...testInviteWithoutUser,
    type: "user",
    inviter: testUserWithoutInvite,
  },
};

const serializedUserInvitedByUser: Dynamo<User<UserWithoutInvite>> = {
  ...serializedUserWithoutInvite,
  invite: {
    M: {
      ...serializedInviteWithoutUser,
      type: { S: "user" },
      inviter: { M: serializedUserWithoutInvite },
    },
  },
};

const testUserInvitedByAdmin: User<AdminEmail> = {
  ...testUserWithoutInvite,
  invite: {
    ...testInviteWithoutUser,
    type: "admin",
    inviter: {
      adminEmail: "test",
    },
  },
};

const serializedUserInvitedByAdmin: Dynamo<User<AdminEmail>> = {
  ...serializedUserWithoutInvite,
  invite: {
    M: {
      ...serializedInviteWithoutUser,
      type: { S: "admin" },
      inviter: {
        M: {
          adminEmail: { S: "test" },
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
      parseDynamo(serializedUserInvitedByUser, kUserInvitedByUserDynamo)
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
      parseDynamo(serializedUserInvitedByAdmin, kUserInvitedByAdminDynamo)
    ).toEqual(testUserInvitedByAdmin);
  });
});
