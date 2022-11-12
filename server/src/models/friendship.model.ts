import mongoose from "mongoose";

export enum FriendshipType {
  Requested,
  Accepted,
  Denied,
  Blocked,
}

export interface IFriendshipModel extends mongoose.Document {
  sender: string;
  recipient: string;
  type: FriendshipType;
}

const schema = new mongoose.Schema(
  {
    sender: { type: mongoose.Types.ObjectId, ref: "User", required: true },
    recipient: { type: mongoose.Types.ObjectId, ref: "User", required: true },
    type: { type: String, enum: FriendshipType, required: true },
  },
  {
    collection: "friendships",
  }
);

schema.index({ sender: 1, recipient: 1 });
schema.index({ sender: 1, type: 1 });
schema.index({ recipient: 1, type: 1 });

export const Friendship = mongoose.model<IFriendshipModel>(
  "Friendship",
  schema
);
