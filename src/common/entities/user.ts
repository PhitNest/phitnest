import { SerializedDynamo, DynamoParser } from "./dynamo";
import {
  AccountDetails,
  CreationDetails,
  creationDetailsToDynamo,
  kAccountDetailsParser,
  kCreationDetailsParser,
} from "./account";
import {
  AdminInvite,
  InviteWithoutSender,
  UserInvite,
  adminInviteToDynamo,
  inviteWithoutSenderToDynamo,
  userInviteToDynamo,
} from "./invite";
import { kGymWithoutAdminParser } from "./gym";
import { kAdminParser } from "./admin";

export type UserExplore = CreationDetails & {
  firstName: string;
  lastName: string;
};

export const kUserExploreParser: DynamoParser<UserExplore> = {
  ...kCreationDetailsParser,
  firstName: "S",
  lastName: "S",
};

export type UserWithoutInvite = UserExplore &
  AccountDetails & {
    numInvites: number;
  };

export const kUserWithoutInviteParser: DynamoParser<UserWithoutInvite> = {
  ...kAccountDetailsParser,
  ...kUserExploreParser,
  numInvites: "N",
};

export type UserWithPartialInvite = UserWithoutInvite & {
  invite: InviteWithoutSender;
};

export const kUserWithPartialInviteParser: DynamoParser<UserWithPartialInvite> =
  {
    ...kUserWithoutInviteParser,
    invite: {
      type: "S",
      receiverEmail: "S",
      createdAt: "D",
      gym: kGymWithoutAdminParser,
    },
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
      id: kAdminParser.id,
      email: kAdminParser.email,
    },
  },
};

export function userExploreToDynamo(
  userExplore: UserExplore
): SerializedDynamo<UserExplore> {
  return {
    firstName: { S: userExplore.firstName },
    lastName: { S: userExplore.lastName },
    ...creationDetailsToDynamo(userExplore),
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

export function userWithPartialInviteToDynamo(
  user: UserWithPartialInvite
): SerializedDynamo<UserWithPartialInvite> {
  return {
    invite: { M: inviteWithoutSenderToDynamo(user.invite) },
    ...userWithoutInviteToDynamo(user),
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
