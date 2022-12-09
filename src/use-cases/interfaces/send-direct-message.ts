import { IDirectMessageEntity } from "../../entities";
import { IUseCase } from "../types";

export interface ISendDirectMessageUseCase extends IUseCase {
  execute(
    senderCognitoId: string,
    recipientCognitoId: string,
    text: string
  ): Promise<IDirectMessageEntity>;
}
