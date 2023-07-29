import { omit } from "lodash";
import { SerializedDynamo, parseDynamo } from "./dynamo";
import { InviteWithoutSender } from "./invite";
import {
  UserInvitedByAdmin,
  UserInvitedByAdminWithoutIdentity,
  UserInvitedByUser,
  UserInvitedByUserWithoutIdentity,
  UserWithoutInvite,
  kUserInvitedByAdminParser,
  kUserInvitedByAdminWithoutIdentityParser,
  kUserInvitedByUserParser,
  kUserInvitedByUserWithoutIdentityParser,
  kUserWithoutInviteParser,
  userInvitedByAdminToDynamo,
  userInvitedByAdminWithoutIdentityToDynamo,
  userInvitedByUserToDynamo,
  userInvitedByUserWithoutIdentityToDynamo,
  userWithoutInviteToDynamo,
} from "./user";

const kTestUserWithoutInvite: UserWithoutInvite = {
  id: "test",
  email: "test",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  firstName: "test",
  lastName: "test",
  numInvites: 1,
  identityId: "test",
};

const kSerializedUserWithoutInvite: SerializedDynamo<UserWithoutInvite> = {
  id: { S: "test" },
  email: { S: "test" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  firstName: { S: "test" },
  lastName: { S: "test" },
  numInvites: { N: "1" },
  identityId: { S: "test" },
};

const kTestInviteWithoutSender: InviteWithoutSender = {
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

const kSerializedInviteWithoutSender: SerializedDynamo<InviteWithoutSender> = {
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

const kTestUserInvitedByUser: UserInvitedByUser = {
  ...kTestUserWithoutInvite,
  invite: {
    ...kTestInviteWithoutSender,
    type: "user",
    inviter: kTestUserWithoutInvite,
  },
};

const kSerializedUserInvitedByUser: SerializedDynamo<UserInvitedByUser> = {
  ...kSerializedUserWithoutInvite,
  invite: {
    M: {
      ...kSerializedInviteWithoutSender,
      type: { S: "user" },
      inviter: { M: kSerializedUserWithoutInvite },
    },
  },
};

const kTestUserInvitedByAdmin: UserInvitedByAdmin = {
  ...kTestUserWithoutInvite,
  invite: {
    ...kTestInviteWithoutSender,
    type: "admin",
    inviter: {
      email: "test",
      id: "test",
    },
  },
};

const kSerializedUserInvitedByAdmin: SerializedDynamo<UserInvitedByAdmin> = {
  ...kSerializedUserWithoutInvite,
  invite: {
    M: {
      ...kSerializedInviteWithoutSender,
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

const kTestUserInvitedByUserWithoutIdentity: UserInvitedByUserWithoutIdentity =
  omit(kTestUserInvitedByUser, "identityId");

const kSerializedUserInvitedByUserWithoutIdentity: SerializedDynamo<UserInvitedByUserWithoutIdentity> =
  omit(kSerializedUserInvitedByUser, "identityId");

const kTestUserInvitedByAdminWithoutIdentity: UserInvitedByAdminWithoutIdentity =
  omit(kTestUserInvitedByAdmin, "identityId");

const kSerializedUserInvitedByAdminWithoutIdentity: SerializedDynamo<UserInvitedByAdminWithoutIdentity> =
  omit(kSerializedUserInvitedByAdmin, "identityId");

describe("User without invite", () => {
  it("serializes to dynamo", () => {
    expect(userWithoutInviteToDynamo(kTestUserWithoutInvite)).toEqual(
      kSerializedUserWithoutInvite
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(kSerializedUserWithoutInvite, kUserWithoutInviteParser)
    ).toEqual(kTestUserWithoutInvite);
  });
});

describe("User invited by user", () => {
  it("serializes to dynamo", () => {
    expect(userInvitedByUserToDynamo(kTestUserInvitedByUser)).toEqual(
      kSerializedUserInvitedByUser
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(kSerializedUserInvitedByUser, kUserInvitedByUserParser)
    ).toEqual(kTestUserInvitedByUser);
  });
});

describe("User invited by admin", () => {
  it("serializes to dynamo", () => {
    expect(userInvitedByAdminToDynamo(kTestUserInvitedByAdmin)).toEqual(
      kSerializedUserInvitedByAdmin
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(kSerializedUserInvitedByAdmin, kUserInvitedByAdminParser)
    ).toEqual(kTestUserInvitedByAdmin);
  });
});

describe("User invited by user without identity id", () => {
  it("serializes to dynamo", () => {
    expect(
      userInvitedByUserWithoutIdentityToDynamo(
        kTestUserInvitedByUserWithoutIdentity
      )
    ).toEqual(kSerializedUserInvitedByUserWithoutIdentity);
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(
        kSerializedUserInvitedByUserWithoutIdentity,
        kUserInvitedByUserWithoutIdentityParser
      )
    ).toEqual(kTestUserInvitedByUserWithoutIdentity);
  });
});

describe("User invited by admin without identity id", () => {
  it("serializes to dynamo", () => {
    expect(
      userInvitedByAdminWithoutIdentityToDynamo(
        kTestUserInvitedByAdminWithoutIdentity
      )
    ).toEqual(kSerializedUserInvitedByAdminWithoutIdentity);
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(
        kSerializedUserInvitedByAdminWithoutIdentity,
        kUserInvitedByAdminWithoutIdentityParser
      )
    ).toEqual(kTestUserInvitedByAdminWithoutIdentity);
  });
});
