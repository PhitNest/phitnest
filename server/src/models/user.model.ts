import mongoose from "mongoose";

export interface IUserModel extends mongoose.Document {
  email: string;
  firstName: string;
  lastName: string;
}

const schema = new mongoose.Schema(
  {
    email: { type: String, required: true, unique: true, trim: true },
    firstName: { type: String, required: true, trim: true },
    lastName: { type: String, required: true, trim: true },
  },
  {
    collection: "users",
  }
);

export const User = mongoose.model<IUserModel>("User", schema);
