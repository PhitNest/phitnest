import {
  GymWithoutAdmin,
  gymWithoutAdminToDynamo,
  kGymWithoutAdminDynamo,
} from "./gym";
import {
  InviteTypes,
  InviteWithoutGym,
  adminInviteWithoutGymToDynamo,
  inviteWithoutGymToDynamo,
  kAdminInviteWithoutGymDynamo,
  kInviteWithoutGymDynamo,
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
  gym: GymWithoutAdmin;
  numInvites: number;
};

export const kUserWithoutInviteDynamo: DynamoShape<UserWithoutInvite> = {
  ...kUserExploreDynamo,
  accountDetails: kAccountDynamo,
  gym: kGymWithoutAdminDynamo,
  numInvites: "N",
};

export type User<InviteType extends InviteTypes = InviteTypes> =
  UserWithoutInvite & {
    invite: InviteWithoutGym<InviteType>;
  };

export const kUserInvitedByUserDynamo: DynamoShape<User<"user">> = {
  ...kUserWithoutInviteDynamo,
  invite: kInviteWithoutGymDynamo,
};

export const kUserInvitedByAdminDynamo: DynamoShape<User<"admin">> = {
  ...kUserWithoutInviteDynamo,
  invite: kAdminInviteWithoutGymDynamo,
};

function nameToDynamo(name: Name): Dynamo<Name> {
  return {
    firstName: { S: name.firstName },
    lastName: { S: name.lastName },
  };
}

export function userInvitedByUserToDynamo(
  user: User<"user">
): Dynamo<User<"user">> {
  return {
    invite: { M: inviteWithoutGymToDynamo(user.invite) },
    ...userWithoutInviteToDynamo(user),
  };
}

export function userInvitedByAdminToDynamo(
  user: User<"admin">
): Dynamo<User<"admin">> {
  return {
    invite: { M: adminInviteWithoutGymToDynamo(user.invite) },
    ...userWithoutInviteToDynamo(user),
  };
}

export function userWithoutInviteToDynamo(
  inviter: UserWithoutInvite
): Dynamo<UserWithoutInvite> {
  return {
    accountDetails: { M: accountToDynamo(inviter.accountDetails) },
    gym: { M: gymWithoutAdminToDynamo(inviter.gym) },
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
