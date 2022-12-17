import { IMessageEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetMessagesUseCase extends IUseCase {
  execute(
    userCognitoId: string,
    conversationId: string,
    offset?: number,
    limit?: number
  ): Promise<IMessageEntity[]>;
}
