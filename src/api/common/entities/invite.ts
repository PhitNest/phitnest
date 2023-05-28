import { AttributeValue } from "@aws-sdk/client-dynamodb";
import { Gym } from "./gym";

export type Invite = {
  inviterId: string;
  inviterEmail: string;
  receiverEmail: string;
  createdAt: Date;
  gym: Gym;
};

export function parseInviteFromDynamo(
  queryResult: Record<string, AttributeValue>
) {}
