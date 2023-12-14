import { Invite, kInviteParser } from "../entities";
import { DynamoClient, ResourceNotFound } from "../utils";

type GetInvitesResponse<Limit extends number> = Promise<
  Limit extends 1 ? Invite | ResourceNotFound : Invite[]
>;

type SenderType = "user" | "admin";

const kInviteSkPrefix = "INVITE#";

export function invitePk(senderType: SenderType, senderId: string) {
  return `${senderType.toUpperCase()}#${senderId}`;
}

export function inviteSk(receiverEmail: string) {
  return `${kInviteSkPrefix}${receiverEmail}`;
}

export function inviteKey(
  senderType: SenderType,
  senderId: string,
  receiverEmail: string
) {
  return {
    pk: invitePk(senderType, senderId),
    sk: inviteSk(receiverEmail),
  };
}

export async function getSentInvites<Limit extends number>(
  dynamo: DynamoClient,
  senderId: string,
  senderType: SenderType,
  limit?: Limit
): GetInvitesResponse<Limit> {
  return await dynamo.parsedQuery({
    pk: invitePk(senderType, senderId),
    sk: { q: kInviteSkPrefix, op: "BEGINS_WITH" },
    limit: limit,
    parseShape: kInviteParser,
  });
}

export async function getReceivedInvites<Limit extends number>(
  dynamo: DynamoClient,
  receiverEmail: string,
  limit?: Limit
): GetInvitesResponse<Limit> {
  return await dynamo.parsedQuery({
    pk: inviteSk(receiverEmail),
    table: "inverted",
    limit: limit,
    parseShape: kInviteParser,
  });
}

export async function deleteInvite(
  dynamo: DynamoClient,
  senderId: string,
  receiverEmail: string,
  senderType: SenderType
): Promise<void> {
  await dynamo.delete(inviteKey(senderType, senderId, receiverEmail));
}
