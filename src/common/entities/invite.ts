import { SerializedDynamo, DynamoParser } from "./dynamo";

export type Invite = {
  type: "admin" | "user";
  senderId: string;
  receiverEmail: string;
  createdAt: Date;
  gymId: string;
};

export const kInviteParser: DynamoParser<Invite> = {
  type: "S",
  senderId: "S",
  receiverEmail: "S",
  createdAt: "D",
  gymId: "S",
};

export function inviteToDynamo(invite: Invite): SerializedDynamo<Invite> {
  return {
    type: { S: invite.type },
    senderId: { S: invite.senderId },
    receiverEmail: { S: invite.receiverEmail },
    createdAt: { N: invite.createdAt.getTime().toString() },
    gymId: { S: invite.gymId },
  };
}
