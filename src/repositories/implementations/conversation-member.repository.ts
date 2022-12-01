import mongoose from "mongoose";
import { IConversationMemberEntity } from "../../entities";
import { CONVERSATION_MODEL_NAME } from "./conversation.repository";

export const CONVERSATION_MEMBER_COLLECTION_NAME = "conversation-members";
export const CONVERSATION_MEMBER_MODEL_NAME = "ConversationMember";

const schema = new mongoose.Schema(
  {
    conversationId: {
      type: mongoose.Types.ObjectId,
      ref: CONVERSATION_MODEL_NAME,
      required: true,
    },
    userCognitoId: { type: String, required: true },
  },
  {
    collection: CONVERSATION_MEMBER_COLLECTION_NAME,
  }
);

const ConversationMemberModel = mongoose.model<IConversationMemberEntity>(
  CONVERSATION_MEMBER_MODEL_NAME,
  schema
);

export class MongoConversationMemberRepository {
  create(conversationMember: Omit<IConversationMemberEntity, "_id">) {
    return ConversationMemberModel.create(conversationMember);
  }
}
