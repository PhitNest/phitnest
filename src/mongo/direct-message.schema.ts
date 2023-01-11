import mongoose from "mongoose";
import { IDirectMessageEntity } from "../entities";
import { FRIENDSHIP_MODEL_NAME } from "./friendship.schema";

export const DIRECT_MESSAGE_COLLECTION_NAME = "direct-messages";
export const DIRECT_MESSAGE_MODEL_NAME = "DirectMessage";

const schema = new mongoose.Schema(
  {
    senderCognitoId: { type: String, required: true },
    friendshipId: {
      type: mongoose.Types.ObjectId,
      ref: FRIENDSHIP_MODEL_NAME,
      required: true,
    },
    text: { type: String, required: true },
  },
  {
    collection: DIRECT_MESSAGE_COLLECTION_NAME,
    timestamps: true,
  }
);

export const DirectMessageModel = mongoose.model<IDirectMessageEntity>(
  DIRECT_MESSAGE_MODEL_NAME,
  schema
);
