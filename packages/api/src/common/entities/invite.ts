import { SerializedDynamo, DynamoParser } from "./dynamo";

export type Invite = {
  senderType: "admin" | "user";
  senderId: string;
  receiverEmail: string;
  createdAt: Date;
  gymId: string;
};

export const kInviteParser: DynamoParser<Invite> = {
  senderType: "S",
  senderId: "S",
  receiverEmail: "S",
  createdAt: "D",
  gymId: "S",
};

export function inviteToDynamo(invite: Invite): SerializedDynamo<Invite> {
  return {
    senderType: { S: invite.senderType },
    senderId: { S: invite.senderId },
    receiverEmail: { S: invite.receiverEmail },
    createdAt: { N: invite.createdAt.getTime().toString() },
    gymId: { S: invite.gymId },
  };
}
