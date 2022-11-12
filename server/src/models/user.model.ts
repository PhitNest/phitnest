import mongoose from "mongoose";

export interface IUserModel extends mongoose.Document {
  cognitoId: string;
  gymId: string;
  email: string;
  firstName: string;
  lastName: string;
}

export interface IPublicUserModel extends mongoose.Document {
  cognitoId: string;
  gymId: string;
  firstName: string;
  lastName: string;
}

const schema = new mongoose.Schema(
  {
    cognitoId: { type: String, required: true, unique: true },
    gymId: { type: mongoose.Types.ObjectId, ref: "Gym", required: true },
    email: { type: String, required: true, unique: true, trim: true },
    firstName: { type: String, required: true, trim: true },
    lastName: { type: String, required: true, trim: true },
  },
  {
    collection: "users",
  }
);

schema.index({ gymId: 1 });

export const User = mongoose.model<IUserModel>("User", schema);
