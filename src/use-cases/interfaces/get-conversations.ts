import { IConversationEntity } from "../../entities";
import { IUseCase } from "../types";

export interface IGetConversationsUseCase extends IUseCase {
  execute(cognitoId: string): Promise<IConversationEntity[]>;
}
