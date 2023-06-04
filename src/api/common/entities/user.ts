import {
  Invite,
  InviterTypes,
  adminInviteToDynamo,
  inviteToDynamo,
  kAdminInviteDynamo,
  kInviteDynamo,
} from "./invite";
import { Dynamo, DynamoShape } from "./dynamo";
import {
  Account,
  CreationDetails,
  accountToDynamo,
  creationDetailsToDynamo,
  kAccountDynamo,
  kCreationDetailsDynamo,
} from "./account";
import { Admin } from "./admin";

type Name = {
  firstName: string;
  lastName: string;
};

const kNameDynamo: DynamoShape<Name> = {
  firstName: "S",
  lastName: "S",
};

export type UserExplore = Name & {
  accountDetails: CreationDetails;
};

export const kUserExploreDynamo: DynamoShape<UserExplore> = {
  ...kNameDynamo,
  accountDetails: kCreationDetailsDynamo,
};

export type UserWithoutInvite = UserExplore & {
  accountDetails: Account;
  numInvites: number;
};

export const kUserWithoutInviteDynamo: DynamoShape<UserWithoutInvite> = {
  ...kUserExploreDynamo,
  accountDetails: kAccountDynamo,
  numInvites: "N",
};

export type User<InviteType extends InviterTypes = InviterTypes> =
  UserWithoutInvite & {
    invite: Invite<InviteType>;
  };

export const kUserInvitedByUserDynamo: DynamoShape<User<UserWithoutInvite>> = {
  ...kUserWithoutInviteDynamo,
  invite: kInviteDynamo,
};

export const kUserInvitedByAdminDynamo: DynamoShape<User<Admin>> = {
  ...kUserWithoutInviteDynamo,
  invite: kAdminInviteDynamo,
};

function nameToDynamo(name: Name): Dynamo<Name> {
  return {
    firstName: { S: name.firstName },
    lastName: { S: name.lastName },
  };
}

export function userInvitedByUserToDynamo(
  user: User<UserWithoutInvite>
): Dynamo<User<UserWithoutInvite>> {
  return {
    invite: { M: inviteToDynamo(user.invite) },
    ...userWithoutInviteToDynamo(user),
  };
}

export function userInvitedByAdminToDynamo(
  user: User<Admin>
): Dynamo<User<Admin>> {
  return {
    invite: { M: adminInviteToDynamo(user.invite) },
    ...userWithoutInviteToDynamo(user),
  };
}

export function userWithoutInviteToDynamo(
  user: UserWithoutInvite
): Dynamo<UserWithoutInvite> {
  return {
    accountDetails: { M: accountToDynamo(user.accountDetails) },
    numInvites: { N: user.numInvites.toString() },
    ...nameToDynamo(user),
  };
}

export function userExploreToDynamo(user: UserExplore): Dynamo<UserExplore> {
  return {
    accountDetails: { M: creationDetailsToDynamo(user.accountDetails) },
    ...nameToDynamo(user),
  };
}
