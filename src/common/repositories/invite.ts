import { Invite, inviteToDynamo, kInviteParser } from "common/entities";
import { DynamoClient, PutParams, ResourceNotFoundError } from "common/utils";

type GetInvitesResponse<Limit extends number> = Promise<
  Limit extends 1 ? Invite | ResourceNotFoundError : Invite[]
>;

const kInviteSkPrefix = "INVITE#";

export async function getSentInvites<Limit extends number>(
  dynamo: DynamoClient,
  senderId: string,
  senderType: "user" | "admin",
  limit?: Limit
): GetInvitesResponse<Limit> {
  return await dynamo.parsedQuery({
    pk: `${senderType.toUpperCase()}#${senderId}`,
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
    pk: `${kInviteSkPrefix}${receiverEmail}`,
    table: "inverted",
    limit: limit,
    parseShape: kInviteParser,
  });
}

export function createInviteParameters(params: {
  senderId: string;
  receiverEmail: string;
  senderType: "user" | "admin";
  gymId: string;
}): PutParams {
  return {
    pk: `${params.senderType.toUpperCase()}#${params.senderId}`,
    sk: `${kInviteSkPrefix}${params.receiverEmail}`,
    data: inviteToDynamo({
      ...params,
      createdAt: new Date(),
      senderType: params.senderType,
    }),
  };
}

export function deleteInvite(
  dynamo: DynamoClient,
  senderId: string,
  receiverEmail: string,
  senderType: "user" | "admin"
): Promise<void> {
  return dynamo.delete({
    pk: `${senderType.toUpperCase()}#${senderId}`,
    sk: `${kInviteSkPrefix}${receiverEmail}`,
  });
}
