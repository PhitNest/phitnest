import { SerializedDynamo, DynamoParser } from "./dynamo";

export type Invite = {
  __poly__: "Invite";
  receiverEmail: string;
  createdAt: Date;
  gymId: string;
};

export const kInviteParser: DynamoParser<Invite> = {
  __poly__: "S",
  receiverEmail: "S",
  createdAt: "D",
  gymId: "S",
};

export type UserInvite = Omit<Invite, "__poly__"> & {
  __poly__: "UserInvite";
  senderId: string;
};

export const kUserInviteParser: DynamoParser<UserInvite> = {
  ...kInviteParser,
  senderId: "S",
};

export function inviteToDynamo(invite: Invite): SerializedDynamo<Invite> {
  return {
    __poly__: { S: invite.__poly__ },
    receiverEmail: { S: invite.receiverEmail },
    createdAt: { N: invite.createdAt.getTime().toString() },
    gymId: { S: invite.gymId },
  };
}

export function userInviteToDynamo(
  invite: UserInvite,
): SerializedDynamo<UserInvite> {
  return {
    ...inviteToDynamo({ ...invite, __poly__: "Invite" }),
    __poly__: { S: invite.__poly__ },
    senderId: { S: invite.senderId },
  };
}
