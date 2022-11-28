import { IPublicUserEntity } from "../../entities";

export interface IRelationshipRepository {
  createBlock(senderId: string, recipientId: string): Promise<void>;
  deleteBlock(senderId: string, recipientId: string): Promise<void>;
  createRequest(senderId: string, recipientId: string): Promise<void>;
  createDeny(senderId: string, recipientId: string): Promise<void>;
  getPendingOutboundRequests(
    cognitoId: string
  ): Promise<IPublicUserEntity[]>;
  getPendingInboundRequests(
    cognitoId: string
  ): Promise<IPublicUserEntity[]>;
  getFriends(cognitoId: string): Promise<IPublicUserEntity[]>;
}
