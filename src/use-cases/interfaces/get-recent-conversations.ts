import { IMessageEntity, IPopulatedConversationEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetRecentConversationsUseCase extends IUseCase {
  execute(cognitoId: string): Promise<
    {
      conversation: IPopulatedConversationEntity;
      message: IMessageEntity;
    }[]
  >;
}
