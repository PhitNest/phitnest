import mongoose from "mongoose";

export enum RelationshipType {
  Requested = "Requested",
  Denied = "Denied",
  Blocked = "Blocked",
}

export interface IRelationshipEntity extends mongoose.Document {
  sender: Readonly<string>;
  recipient: Readonly<string>;
  type: Readonly<RelationshipType>;
}
