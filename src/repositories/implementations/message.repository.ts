import mongoose from "mongoose";
import { IMessageEntity } from "../../entities";
import { IMessageRepository } from "../interfaces";
import { CONVERSATION_MODEL_NAME } from "./conversation.repository";

export const MESSAGE_COLLECTION_NAME = "messages";
export const MESSAGE_MODEL_NAME = "Message";

const schema = new mongoose.Schema(
  {
    conversationId: {
      type: mongoose.Types.ObjectId,
      ref: CONVERSATION_MODEL_NAME,
      required: true,
    },
    userCognitoId: { type: String, required: true },
    text: { type: String, required: true, trim: true },
  },
  {
    collection: MESSAGE_COLLECTION_NAME,
    timestamps: true,
  }
);

schema.index({ conversationId: 1 });

const MessageModel = mongoose.model<IMessageEntity>(MESSAGE_MODEL_NAME, schema);

export class MongoMessageRepository implements IMessageRepository {
  create(message: Omit<IMessageEntity, "_id">) {
    return MessageModel.create(message);
  }
}
