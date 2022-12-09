import {
  IDirectConversationEntity,
  IDirectMessageEntity,
} from "../../entities";

export interface IDirectConversationRepository {
  create(userCognitoIds: [string, string]): Promise<IDirectConversationEntity>;

  getByUser(cognitoId: string): Promise<IDirectConversationEntity[]>;

  getByUsers(
    cognitoIds: [string, string]
  ): Promise<IDirectConversationEntity | null>;

  delete(conversationId: string): Promise<boolean>;

  getRecentMessages(
    cognitoId: string
  ): Promise<
    { conversation: IDirectConversationEntity; message: IDirectMessageEntity }[]
  >;
}
