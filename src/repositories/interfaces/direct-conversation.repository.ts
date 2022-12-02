import { IDirectConversationEntity } from "../../entities";

export interface IDirectConversationRepository {
  create(userCognitoIds: [string, string]): Promise<IDirectConversationEntity>;

  getByUser(cognitoId: string): Promise<IDirectConversationEntity[]>;

  getByUsers(
    cognitoIds: [string, string]
  ): Promise<IDirectConversationEntity | null>;
}
