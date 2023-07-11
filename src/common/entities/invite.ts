import {
  UserWithoutInvite,
  kUserWithoutInviteParser,
  userWithoutInviteToDynamo,
} from "./user";
import {
  GymWithoutAdmin,
  gymWithoutAdminToDynamo,
  kGymWithoutAdminParser,
} from "./gym";
import { SerializedDynamo, DynamoParser } from "./dynamo";
import { Admin, kAdminParser } from "./admin";

export type InviteWithoutSender = {
  type: "admin" | "user";
  receiverEmail: string;
  createdAt: Date;
  gym: GymWithoutAdmin;
};

export const kInviteWithoutSenderParser: DynamoParser<InviteWithoutSender> = {
  type: "S",
  receiverEmail: "S",
  createdAt: "D",
  gym: kGymWithoutAdminParser,
};

export type AdminInvite = InviteWithoutSender & {
  type: "admin";
  inviter: Omit<Admin, "createdAt">;
};

export type UserInvite = InviteWithoutSender & {
  type: "user";
  inviter: UserWithoutInvite;
};

export const kAdminInviteParser: DynamoParser<AdminInvite> = {
  inviter: {
    id: kAdminParser.id,
    email: kAdminParser.email,
  },
  ...kInviteWithoutSenderParser,
};

export const kUserInviteParser: DynamoParser<UserInvite> = {
  inviter: kUserWithoutInviteParser,
  ...kInviteWithoutSenderParser,
};

export function inviteWithoutSenderToDynamo(
  invite: InviteWithoutSender
): SerializedDynamo<InviteWithoutSender> {
  return {
    type: { S: invite.type },
    receiverEmail: { S: invite.receiverEmail },
    createdAt: { N: invite.createdAt.getTime().toString() },
    gym: { M: gymWithoutAdminToDynamo(invite.gym) },
  };
}

export function userInviteToDynamo(
  invite: UserInvite
): SerializedDynamo<UserInvite> {
  return {
    ...inviteWithoutSenderToDynamo(invite),
    type: { S: "user" },
    inviter: { M: userWithoutInviteToDynamo(invite.inviter) },
  };
}

export function adminInviteToDynamo(
  invite: AdminInvite
): SerializedDynamo<AdminInvite> {
  return {
    ...inviteWithoutSenderToDynamo(invite),
    type: { S: "admin" },
    inviter: {
      M: {
        email: { S: invite.inviter.email },
        id: { S: invite.inviter.id },
      },
    },
  };
}
