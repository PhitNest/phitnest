import { IUserEntity } from "../../entities";

export interface IRelationshipRepository {
  createBlock(senderId: string, recipientId: string): Promise<void>;
  deleteBlock(senderId: string, recipientId: string): Promise<void>;
  createRequest(senderId: string, recipientId: string): Promise<void>;
  createDeny(senderId: string, recipientId: string): Promise<void>;
  getPendingOutboundRequests(
    cognitoId: string
  ): Promise<Omit<IUserEntity, "email">[]>;
  getPendingInboundRequests(
    cognitoId: string
  ): Promise<Omit<IUserEntity, "email">[]>;
  getFriends(cognitoId: string): Promise<Omit<IUserEntity, "email">[]>;
}
