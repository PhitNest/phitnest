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

export type Inviter = UserExplore & {
  accountDetails: Account;
  numInvites: number;
};

export const kInviterDynamo: DynamoShape<Inviter> = {
  ...kUserExploreDynamo,
  accountDetails: kAccountDynamo,
  numInvites: "N",
};

export type User<InviteType extends InviterTypes = InviterTypes> = Inviter & {
  invite: Invite<InviteType>;
};

export const kUserInvitedByUserDynamo: DynamoShape<User<Inviter>> = {
  ...kInviterDynamo,
  invite: kInviteDynamo,
};

export const kUserInvitedByAdminDynamo: DynamoShape<User<Admin>> = {
  ...kInviterDynamo,
  invite: kAdminInviteDynamo,
};

function nameToDynamo(name: Name): Dynamo<Name> {
  return {
    firstName: { S: name.firstName },
    lastName: { S: name.lastName },
  };
}

export function userInvitedByUserToDynamo(
  user: User<Inviter>
): Dynamo<User<Inviter>> {
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

export function userWithoutInviteToDynamo(inviter: Inviter): Dynamo<Inviter> {
  return {
    accountDetails: { M: accountToDynamo(inviter.accountDetails) },
    numInvites: { N: inviter.numInvites.toString() },
    ...nameToDynamo(inviter),
  };
}

export function userExploreToDynamo(user: UserExplore): Dynamo<UserExplore> {
  return {
    accountDetails: { M: creationDetailsToDynamo(user.accountDetails) },
    ...nameToDynamo(user),
  };
}
