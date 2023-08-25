import { SerializedDynamo, DynamoParser } from "./dynamo";
import {
  AdminInvite,
  InviteWithoutSender,
  UserInvite,
  adminInviteToDynamo,
  inviteWithoutSenderToDynamo,
  userInviteToDynamo,
} from "./invite";
import { kGymWithoutAdminParser } from "./gym";

export type UserWithoutIdentity = {
  id: string;
  firstName: string;
  lastName: string;
  createdAt: Date;
};

export const kUserWithoutIdentityParser: DynamoParser<UserWithoutIdentity> = {
  id: "S",
  firstName: "S",
  lastName: "S",
  createdAt: "D",
};

export type UserExplore = UserWithoutIdentity & {
  identityId: string;
};

export const kUserExploreParser: DynamoParser<UserExplore> = {
  ...kUserWithoutIdentityParser,
  identityId: "S",
};

type _UserWithoutInvite = {
  email: string;
  numInvites: number;
};

const kUserWithoutInviteShape: DynamoParser<_UserWithoutInvite> = {
  email: "S",
  numInvites: "N",
};

export type UserWithoutInvite = UserExplore & _UserWithoutInvite;

export type UserWithoutInviteOrIdentity = UserWithoutIdentity &
  _UserWithoutInvite;

export const kUserWithoutInviteParser: DynamoParser<UserWithoutInvite> = {
  ...kUserExploreParser,
  ...kUserWithoutInviteShape,
};

export const kUserWithoutInviteOrIdentityParser: DynamoParser<UserWithoutInviteOrIdentity> =
  {
    ...kUserWithoutIdentityParser,
    ...kUserWithoutInviteShape,
  };

type _PartialInvite = {
  invite: InviteWithoutSender;
};

const kPartialInviteShape: DynamoParser<_PartialInvite> = {
  invite: {
    type: "S",
    receiverEmail: "S",
    createdAt: "D",
    gym: kGymWithoutAdminParser,
  },
};

export type UserWithPartialInvite = UserWithoutInvite & _PartialInvite;

export const kUserWithPartialInviteParser: DynamoParser<UserWithPartialInvite> =
  {
    ...kUserWithoutInviteParser,
    ...kPartialInviteShape,
  };

export type UserWithoutIdentityPartialInvite = UserWithoutInviteOrIdentity &
  _PartialInvite;

export const kUserWithoutIdentityPartialInviteParser: DynamoParser<UserWithoutIdentityPartialInvite> =
  {
    ...kUserWithoutInviteOrIdentityParser,
    ...kPartialInviteShape,
  };

export type UserInvitedByAdmin = UserWithoutInvite & {
  invite: AdminInvite;
};

export type UserInvitedByUser = UserWithoutInvite & {
  invite: UserInvite;
};

export const kUserInvitedByUserParser: DynamoParser<UserInvitedByUser> = {
  ...kUserWithoutInviteParser,
  invite: {
    ...kUserWithPartialInviteParser.invite,
    inviter: kUserWithoutInviteParser,
  },
};

export const kUserInvitedByAdminParser: DynamoParser<UserInvitedByAdmin> = {
  ...kUserWithoutInviteParser,
  invite: {
    ...kUserWithPartialInviteParser.invite,
    inviter: {
      id: "S",
      email: "S",
    },
  },
};

export type UserInvitedByAdminWithoutIdentity = UserWithoutInviteOrIdentity & {
  invite: AdminInvite;
};

export type UserInvitedByUserWithoutIdentity = UserWithoutInviteOrIdentity & {
  invite: UserInvite;
};

export const kUserInvitedByUserWithoutIdentityParser: DynamoParser<UserInvitedByUserWithoutIdentity> =
  {
    ...kUserWithoutInviteOrIdentityParser,
    invite: {
      ...kUserWithPartialInviteParser.invite,
      inviter: kUserWithoutInviteParser,
    },
  };

export const kUserInvitedByAdminWithoutIdentityParser: DynamoParser<UserInvitedByAdminWithoutIdentity> =
  {
    ...kUserWithoutInviteOrIdentityParser,
    invite: {
      ...kUserWithPartialInviteParser.invite,
      inviter: {
        id: "S",
        email: "S",
      },
    },
  };

export function userWithoutIdentityToDynamo(
  user: UserWithoutIdentity
): SerializedDynamo<UserWithoutIdentity> {
  return {
    id: { S: user.id },
    firstName: { S: user.firstName },
    lastName: { S: user.lastName },
    createdAt: { N: user.createdAt.getTime().toString() },
  };
}

export function userExploreToDynamo(
  userExplore: UserExplore
): SerializedDynamo<UserExplore> {
  return {
    identityId: { S: userExplore.identityId },
    ...userWithoutIdentityToDynamo(userExplore),
  };
}

export function userWithoutInviteToDynamo(
  userExplore: UserWithoutInvite
): SerializedDynamo<UserWithoutInvite> {
  return {
    numInvites: { N: userExplore.numInvites.toString() },
    email: { S: userExplore.email },
    ...userExploreToDynamo(userExplore),
  };
}

export function userWithoutInviteOrIdentityToDynamo(
  user: UserWithoutInviteOrIdentity
): SerializedDynamo<UserWithoutInviteOrIdentity> {
  return {
    numInvites: { N: user.numInvites.toString() },
    email: { S: user.email },
    ...userWithoutIdentityToDynamo(user),
  };
}

export function userWithPartialInviteToDynamo(
  user: UserWithPartialInvite
): SerializedDynamo<UserWithPartialInvite> {
  return {
    invite: { M: inviteWithoutSenderToDynamo(user.invite) },
    ...userWithoutInviteToDynamo(user),
  };
}

export function userWithoutIdentityPartialInviteToDynamo(
  user: UserWithoutIdentityPartialInvite
): SerializedDynamo<UserWithoutIdentityPartialInvite> {
  return {
    invite: { M: inviteWithoutSenderToDynamo(user.invite) },
    ...userWithoutInviteOrIdentityToDynamo(user),
  };
}

export function userInvitedByUserToDynamo(
  user: UserInvitedByUser
): SerializedDynamo<UserInvitedByUser> {
  return {
    invite: { M: userInviteToDynamo(user.invite) },
    ...userWithoutInviteToDynamo(user),
  };
}

export function userInvitedByAdminToDynamo(
  user: UserInvitedByAdmin
): SerializedDynamo<UserInvitedByAdmin> {
  return {
    invite: { M: adminInviteToDynamo(user.invite) },
    ...userWithoutInviteToDynamo(user),
  };
}

export function userInvitedByUserWithoutIdentityToDynamo(
  user: UserInvitedByUserWithoutIdentity
): SerializedDynamo<UserInvitedByUserWithoutIdentity> {
  return {
    invite: { M: userInviteToDynamo(user.invite) },
    ...userWithoutInviteOrIdentityToDynamo(user),
  };
}

export function userInvitedByAdminWithoutIdentityToDynamo(
  user: UserInvitedByAdminWithoutIdentity
): SerializedDynamo<UserInvitedByAdminWithoutIdentity> {
  return {
    invite: { M: adminInviteToDynamo(user.invite) },
    ...userWithoutInviteOrIdentityToDynamo(user),
  };
}
