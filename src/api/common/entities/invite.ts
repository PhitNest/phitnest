import { UserWithoutInvite, userWithoutInviteToDynamo } from "./user";
import {
  GymWithoutAdmin,
  gymWithoutAdminToDynamo,
  kGymWithoutAdminDynamo,
} from "./gym";
import { Dynamo, DynamoShape } from "./dynamo";
import { kAccountDynamo } from "./account";

export type AdminEmail = { adminEmail: string };

export type InviterTypes = AdminEmail | UserWithoutInvite | null;

type InviteType<T extends InviterTypes> = T extends null
  ? "admin" | "user"
  : T extends UserWithoutInvite
  ? "user"
  : "admin";

export type InviteTypeOnly<InviterType extends InviterTypes = null> = {
  type: InviteType<InviterType>;
};

export const kInviteTypeOnlyDynamo: DynamoShape<InviteTypeOnly> = {
  type: "S",
};

export type InviteWithoutUser = {
  receiverEmail: string;
  createdAt: Date;
  gym: GymWithoutAdmin;
};

export const kInviteWithoutUserDynamo: DynamoShape<InviteWithoutUser> = {
  ...kInviteTypeOnlyDynamo,
  receiverEmail: "S",
  createdAt: "D",
  gym: kGymWithoutAdminDynamo,
};

export type Invite<InviterType extends InviterTypes> =
  InviteTypeOnly<InviterType> &
    InviteWithoutUser & {
      inviter: InviterType;
    };

export const kAdminInviteDynamo: DynamoShape<Invite<AdminEmail>> = {
  inviter: { adminEmail: "S" },
  ...kInviteTypeOnlyDynamo,
  ...kInviteWithoutUserDynamo,
};

export const kInviteDynamo: DynamoShape<Invite<UserWithoutInvite>> = {
  inviter: {
    accountDetails: {
      ...kAccountDynamo,
    },
    firstName: "S",
    lastName: "S",
    numInvites: "N",
  },
  ...kInviteTypeOnlyDynamo,
  ...kInviteWithoutUserDynamo,
};

export function inviteWithoutUserToDynamo(
  invite: InviteWithoutUser
): Dynamo<InviteWithoutUser> {
  return {
    receiverEmail: { S: invite.receiverEmail },
    createdAt: { N: invite.createdAt.getTime().toString() },
    gym: { M: gymWithoutAdminToDynamo(invite.gym) },
  };
}

export function inviteToDynamo(
  invite: Invite<UserWithoutInvite>
): Dynamo<Invite<UserWithoutInvite>> {
  return {
    ...inviteWithoutUserToDynamo(invite),
    inviter: { M: userWithoutInviteToDynamo(invite.inviter) },
    type: { S: "user" },
  };
}

export function adminInviteToDynamo(
  invite: Invite<AdminEmail>
): Dynamo<Invite<AdminEmail>> {
  return {
    ...inviteWithoutUserToDynamo(invite),
    inviter: { M: { adminEmail: { S: invite.inviter.adminEmail } } },
    type: { S: "admin" },
  };
}
