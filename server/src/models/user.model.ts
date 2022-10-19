import mongoose from "mongoose";

export interface IUserModel extends mongoose.Document {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
}

const schema = new mongoose.Schema(
  {
    id: { type: String, required: true, unique: true },
    email: { type: String, required: true, unique: true, trim: true },
    firstName: { type: String, required: true, trim: true },
    lastName: { type: String, required: true, trim: true },
  },
  {
    collection: "users",
  }
);

export const User = mongoose.model<IUserModel>("User", schema);