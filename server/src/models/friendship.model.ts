import mongoose from "mongoose";

export interface IFriendshipModel extends mongoose.Document {
  userIdA: string;
  acceptanceA: boolean;
  userIdB: string;
  acceptanceB: boolean;
}

const schema = new mongoose.Schema(
  {
    userIdA: { type: mongoose.Types.ObjectId, ref: "User", required: true },
    acceptanceA: { type: Boolean, required: true },
    userIdB: { type: mongoose.Types.ObjectId, ref: "User", required: true },
    acceptanceB: { type: Boolean, required: true },
  },
  {
    collection: "friendships",
  }
);

schema.index({ userIdA: 1, userIdB: 1 });
schema.index({ userIdA: 1 });
schema.index({ userIdB: 1 });

export const Friendship = mongoose.model<IFriendshipModel>(
  "Friendship",
  schema
);
