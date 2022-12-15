import { IConversationEntity, IMessageEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetRecentConversationsUseCase extends IUseCase {
  execute(cognitoId: string): Promise<
    {
      conversation: IConversationEntity;
      message: IMessageEntity;
    }[]
  >;
}
