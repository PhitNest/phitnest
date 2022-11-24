import { IUserEntity } from "../../entities";

export interface IRelationshipRepository {
  createBlock(senderId: string, recipientId: string): Promise<void>;
  deleteBlock(senderId: string, recipientId: string): Promise<void>;
  createRequest(senderId: string, recipientId: string): Promise<void>;
  createDeny(senderId: string, recipientId: string): Promise<void>;
  getPendingOutboundRequests(senderId: string): Promise<Partial<IUserEntity>[]>;
  getPendingInboundRequests(
    recipientId: string
  ): Promise<Partial<IUserEntity>[]>;
  getFriends(userId: string): Promise<Partial<IUserEntity>[]>;
}
