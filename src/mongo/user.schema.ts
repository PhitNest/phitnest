import mongoose from "mongoose";
import { IUserEntity } from "../entities";
import { GYM_MODEL_NAME } from "./gym.schema";

export const USER_COLLECTION_NAME = "users";
export const USER_MODEL_NAME = "User";

const schema = new mongoose.Schema(
  {
    cognitoId: { type: String, required: true, unique: true },
    gymId: {
      type: mongoose.Types.ObjectId,
      ref: GYM_MODEL_NAME,
      required: true,
    },
    email: {
      type: String,
      format: "email",
      required: true,
      unique: true,
    },
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    confirmed: { type: Boolean, default: false },
  },
  {
    collection: USER_COLLECTION_NAME,
  }
);

schema.index({ gymId: 1 });

export const UserModel = mongoose.model<IUserEntity>(USER_MODEL_NAME, schema);
