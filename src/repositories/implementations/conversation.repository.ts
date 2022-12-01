import mongoose from "mongoose";
import { IConversationEntity } from "../../entities";
import { IConversationRepository } from "../interfaces";

export const CONVERSATION_COLLECTION_NAME = "conversations";
export const CONVERSATION_MODEL_NAME = "Conversation";

const schema = new mongoose.Schema({});

const ConversationModel = mongoose.model<IConversationEntity>(
  CONVERSATION_MODEL_NAME,
  schema
);

export class MongoConversationRepository implements IConversationRepository {
  create() {
    return ConversationModel.create({});
  }
}
