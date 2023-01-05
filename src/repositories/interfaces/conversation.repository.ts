import {
  IConversationEntity,
  IMessageEntity,
  IPopulatedConversationEntity,
} from "../../entities";

export interface IConversationRepository {
  create(userCognitoIds: string[]): Promise<IConversationEntity>;

  getByUser(cognitoId: string): Promise<IConversationEntity[]>;

  getByUsers(cognitoIds: string[]): Promise<IConversationEntity | null>;

  archive(conversationId: string): Promise<void>;

  getRecentMessages(cognitoId: string): Promise<
    {
      conversation: IPopulatedConversationEntity;
      message: IMessageEntity;
    }[]
  >;

  isUserInConversation(
    userCognitoId: string,
    conversationId: string
  ): Promise<boolean>;

  deleteAll(): Promise<void>;
}
