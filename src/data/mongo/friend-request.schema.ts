import mongoose from "mongoose";
import { IFriendRequestEntity } from "../../domain/entities";

export const FRIEND_REQUEST_COLLECTION_NAME = "friend-requests";
export const FRIEND_REQUEST_MODEL_NAME = "FriendRequest";

const schema = new mongoose.Schema(
  {
    fromCognitoId: { type: String, required: true },
    toCognitoId: { type: String, required: true },
    denied: { type: Boolean, default: false },
  },
  {
    collection: FRIEND_REQUEST_COLLECTION_NAME,
    timestamps: true,
  }
);

schema.index({ fromCognitoId: 1, toCognitoId: 1 }, { unique: true });
schema.index({ fromCognitoId: 1 });
schema.index({ toCognitoId: 1 });

export const FriendRequestModel = mongoose.model<IFriendRequestEntity>(
  FRIEND_REQUEST_MODEL_NAME,
  schema
);
