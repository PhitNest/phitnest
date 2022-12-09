import {
  IDirectConversationEntity,
  IDirectMessageEntity,
} from "../../entities";
import { IUseCase } from "../types";

export interface IGetRecentDirectConversationsUseCase extends IUseCase {
  execute(
    cognitoId: string
  ): Promise<
    { conversation: IDirectConversationEntity; message: IDirectMessageEntity }[]
  >;
}
