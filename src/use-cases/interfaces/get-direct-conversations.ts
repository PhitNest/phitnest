import { IDirectConversationEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetDirectConversationsUseCase extends IUseCase {
  execute(cognitoId: string): Promise<IDirectConversationEntity[]>;
}
