import {
  UserWithoutInvite,
  kUserWithoutInviteDynamo,
  userWithoutInviteToDynamo,
} from "./user";
import { Admin, adminToDynamo, kAdminDynamo } from "./admin";
import {
  GymWithoutAdmin,
  gymWithoutAdminToDynamo,
  kGymWithoutAdminDynamo,
} from "./gym";
import { Dynamo, DynamoShape } from "./dynamo";

export type InviteTypes = "admin" | "user";

export type InviteWithoutUserOrGym<
  InviteType extends InviteTypes = InviteTypes
> = {
  receiverEmail: string;
  createdAt: Date;
  type: InviteType;
};

export const kInviteWithoutUserOrGymDynamo: DynamoShape<InviteWithoutUserOrGym> =
  {
    receiverEmail: "S",
    createdAt: "N",
    type: "S",
  };

export type InviteWithoutUser<InviteType extends InviteTypes = InviteTypes> =
  InviteWithoutUserOrGym<InviteType> & {
    gym: GymWithoutAdmin;
  };

export const kInviteWithoutUserDynamo: DynamoShape<InviteWithoutUser> = {
  ...kInviteWithoutUserOrGymDynamo,
  gym: kGymWithoutAdminDynamo,
};

export type InviteWithoutGym<InviteType extends InviteTypes> =
  InviteWithoutUserOrGym<InviteType> & {
    inviter: InviteType extends "admin" ? Admin : UserWithoutInvite;
  };

export const kAdminInviteWithoutGymDynamo: DynamoShape<
  InviteWithoutGym<"admin">
> = {
  ...kInviteWithoutUserDynamo,
  inviter: kAdminDynamo,
};

export const kInviteWithoutGymDynamo: DynamoShape<InviteWithoutGym<"user">> = {
  ...kInviteWithoutUserDynamo,
  inviter: kUserWithoutInviteDynamo,
};

export type Invite<InviteType extends InviteTypes> =
  InviteWithoutGym<InviteType> & InviteWithoutUser<InviteType>;

export const kAdminInviteDynamo: DynamoShape<Invite<"admin">> = {
  ...kAdminInviteWithoutGymDynamo,
  ...kInviteWithoutUserDynamo,
};

export const kInviteDynamo: DynamoShape<Invite<"user">> = {
  ...kInviteWithoutGymDynamo,
  ...kInviteWithoutUserDynamo,
};

export function removeGym<InviteType extends InviteTypes>(
  invite: Invite<InviteType>
): InviteWithoutGym<InviteType> {
  const result: Omit<Invite<InviteType>, "gym"> & { gym?: GymWithoutAdmin } = {
    ...invite,
  };
  delete result.gym;
  return result;
}

function inviteWithoutUserOrGymToDynamo(
  invite: InviteWithoutUserOrGym
): Dynamo<InviteWithoutUserOrGym> {
  return {
    receiverEmail: { S: invite.receiverEmail },
    createdAt: { N: invite.createdAt.getTime().toString() },
    type: { S: invite.type },
  };
}

export function inviteWithoutUserToDynamo(
  invite: InviteWithoutUser
): Dynamo<InviteWithoutUser> {
  return {
    ...inviteWithoutUserOrGymToDynamo(invite),
    gym: { M: gymWithoutAdminToDynamo(invite.gym) },
  };
}

export function inviteWithoutGymToDynamo(
  invite: InviteWithoutGym<"user">
): Dynamo<InviteWithoutGym<"user">> {
  return {
    ...inviteWithoutUserOrGymToDynamo(invite),
    inviter: { M: userWithoutInviteToDynamo(invite.inviter) },
  };
}

export function adminInviteWithoutGymToDynamo(
  invite: InviteWithoutGym<"admin">
): Dynamo<InviteWithoutGym<"admin">> {
  return {
    ...inviteWithoutUserOrGymToDynamo(invite),
    inviter: { M: adminToDynamo(invite.inviter) },
  };
}

export function inviteToDynamo(invite: Invite<"user">): Dynamo<Invite<"user">> {
  return {
    ...inviteWithoutGymToDynamo(invite),
    ...inviteWithoutUserToDynamo(invite),
  };
}

export function adminInviteToDynamo(
  invite: Invite<"admin">
): Dynamo<Invite<"admin">> {
  return {
    ...adminInviteWithoutGymToDynamo(invite),
    ...inviteWithoutUserToDynamo(invite),
  };
}
