import mongoose from "mongoose";
import { IFriendshipEntity } from "../entities";

export const FRIENDSHIP_COLLECTION_NAME = "friendships";
export const FRIENDSHIP_MODEL_NAME = "Friendship";

const schema = new mongoose.Schema(
  {
    userCognitoIds: { type: [String], required: true },
  },
  {
    collection: FRIENDSHIP_COLLECTION_NAME,
    timestamps: true,
  }
);

schema.index({ userCognitoIds: 1 });

export const FriendshipModel = mongoose.model<IFriendshipEntity>(
  FRIENDSHIP_MODEL_NAME,
  schema
);
