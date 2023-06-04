import { Dynamo, parseDynamo } from "./dynamo";
import { UserWithoutInvite } from "./user";
import {
  Invite,
  InviteWithoutUser,
  adminInviteToDynamo,
  inviteToDynamo,
  kAdminInviteDynamo,
  kInviteDynamo,
} from "./invite";
import { Admin } from "./admin";

const testInviteWithoutUser: InviteWithoutUser = {
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  receiverEmail: "something",
  gym: {
    createdAt: new Date(Date.UTC(2020, 1, 1)),
    id: "1",
    name: "something",
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
      name: { S: "something" },
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

const testInvite: Invite<UserWithoutInvite> = {
  ...testInviteWithoutUser,
  type: "user",
  inviter: {
    accountDetails: {
      createdAt: new Date(Date.UTC(2020, 1, 1)),
      id: "1",
      email: "something",
    },
    firstName: "something",
    lastName: "something",
    numInvites: 5,
  },
};

const serializedInvite: Dynamo<Invite<UserWithoutInvite>> = {
  ...serializedInviteWithoutUser,
  type: { S: "user" },
  inviter: {
    M: {
      accountDetails: {
        M: {
          createdAt: { N: Date.UTC(2020, 1, 1).toString() },
          id: { S: "1" },
          email: { S: "something" },
        },
      },
      firstName: { S: "something" },
      lastName: { S: "something" },
      numInvites: { N: "5" },
    },
  },
};

const testAdminInvite: Invite<Admin> = {
  ...testInviteWithoutUser,
  type: "admin",
  inviter: {
    accountDetails: {
      createdAt: new Date(Date.UTC(2020, 1, 1)),
      id: "1",
      email: "something",
    },
  },
};

const serializedAdminInvite: Dynamo<Invite<Admin>> = {
  ...serializedInviteWithoutUser,
  type: { S: "admin" },
  inviter: {
    M: {
      accountDetails: {
        M: {
          createdAt: { N: Date.UTC(2020, 1, 1).toString() },
          id: { S: "1" },
          email: { S: "something" },
        },
      },
    },
  },
};

describe("Invite from admin", () => {
  it("serializes to dynamo", () => {
    expect(adminInviteToDynamo(testAdminInvite)).toEqual(serializedAdminInvite);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedAdminInvite, kAdminInviteDynamo)).toEqual(
      testAdminInvite
    );
  });
});

describe("Invite", () => {
  it("serializes to dynamo", () => {
    expect(inviteToDynamo(testInvite)).toEqual(serializedInvite);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedInvite, kInviteDynamo)).toEqual(testInvite);
  });
});
