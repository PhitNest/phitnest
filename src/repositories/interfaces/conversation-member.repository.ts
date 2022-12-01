import { IConversationMemberEntity } from "../../entities";

export interface IConversationMemberRepository {
  create(
    conversationMember: Omit<IConversationMemberEntity, "_id">
  ): Promise<IConversationMemberEntity>;
}
