import { IMessageEntity } from "../../entities";
import { IUseCase } from "../types";

export interface ISendMessageUseCase extends IUseCase {
  execute(
    senderCognitoId: string,
    conversationId: string,
    text: string
  ): Promise<IMessageEntity>;
}
