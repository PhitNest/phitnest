import mongoose from "mongoose";

export enum UserRelationshipType {
  Requested,
  Denied,
  Blocked,
}

export interface IUserRelationshipModel extends mongoose.Document {
  sender: string;
  recipient: string;
  type: UserRelationshipType;
}

const schema = new mongoose.Schema(
  {
    sender: { type: mongoose.Types.ObjectId, ref: "User", required: true },
    recipient: { type: mongoose.Types.ObjectId, ref: "User", required: true },
    type: { type: String, enum: UserRelationshipType, required: true },
  },
  {
    collection: "user_relationships",
  }
);

schema.index({ sender: 1, recipient: 1 }, { unique: true });
schema.index({ sender: 1, type: 1 });
schema.index({ recipient: 1, type: 1 });

export const UserRelationship = mongoose.model<IUserRelationshipModel>(
  "User Relationship",
  schema
);
