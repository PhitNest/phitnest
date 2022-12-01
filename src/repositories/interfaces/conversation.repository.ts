import { IConversationEntity } from "../../entities";

export interface IConversationRepository {
  create(): Promise<IConversationEntity>;
}
