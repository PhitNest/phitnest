import mongoose from "mongoose";
import { IDirectMessageEntity } from "../../entities";
import { IDirectMessageRepository } from "../interfaces";
import { DIRECT_CONVERSATION_MODEL_NAME } from "./direct-conversation.repository";

export const DIRECT_MESSAGE_COLLECTION_NAME = "direct-messages";
export const DIRECT_MESSAGE_MODEL_NAME = "DirectMessage";

const schema = new mongoose.Schema(
  {
    conversationId: {
      type: mongoose.Types.ObjectId,
      ref: DIRECT_CONVERSATION_MODEL_NAME,
      required: true,
    },
    userCognitoId: { type: String, required: true },
    content: { type: String, required: true, trim: true },
  },
  {
    collection: DIRECT_MESSAGE_COLLECTION_NAME,
    timestamps: true,
  }
);

schema.index({ conversationId: 1 });

const DirectMessageModel = mongoose.model<IDirectMessageEntity>(
  DIRECT_MESSAGE_MODEL_NAME,
  schema
);

export class MongoDirectMessageRepository implements IDirectMessageRepository {
  create(message: Omit<IDirectMessageEntity, "_id">) {
    return DirectMessageModel.create(message);
  }
}
