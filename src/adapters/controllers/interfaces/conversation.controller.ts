import {
  IMessageEntity,
  IPopulatedConversationEntity,
} from "../../../entities";
import { AuthenticatedController } from "../../types";

export interface IConversationController {
  getRecentConversations: AuthenticatedController<
    { conversation: IPopulatedConversationEntity; message: IMessageEntity }[]
  >;
}
