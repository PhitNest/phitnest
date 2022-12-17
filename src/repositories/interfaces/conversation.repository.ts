import { IConversationEntity, IMessageEntity } from "../../entities";

export interface IConversationRepository {
  create(userCognitoIds: string[]): Promise<IConversationEntity>;

  getByUser(cognitoId: string): Promise<IConversationEntity[]>;

  getByUsers(cognitoIds: string[]): Promise<IConversationEntity | null>;

  delete(conversationId: string): Promise<boolean>;

  getRecentMessages(cognitoId: string): Promise<
    {
      conversation: IConversationEntity;
      message: IMessageEntity;
    }[]
  >;

  isUserInConversation(
    userCognitoId: string,
    conversationId: string
  ): Promise<boolean>;

  deleteAll(): Promise<void>;
}
