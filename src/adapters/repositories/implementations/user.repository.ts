import mongoose from "mongoose";
import { IGymEntity, IUserEntity } from "../../../domain/entities";
import { IUserRepository } from "../interfaces";
import { GYM_COLLECTION_NAME, GYM_MODEL_NAME } from "./gym.repository";

export const USER_COLLECTION_NAME = "users";
export const USER_MODEL_NAME = "User";

const schema = new mongoose.Schema(
  {
    gymId: {
      type: mongoose.Types.ObjectId,
      ref: GYM_MODEL_NAME,
      required: true,
    },
    email: { type: String, required: true, unique: true, trim: true },
    firstName: { type: String, required: true, trim: true },
    lastName: { type: String, required: true, trim: true },
  },
  {
    collection: USER_COLLECTION_NAME,
  }
);

schema.index({ gymId: 1 });

const User = mongoose.model<IUserEntity>(USER_MODEL_NAME, schema);

export class MongoUserRepository implements IUserRepository {
  async getGym(userId: string): Promise<IGymEntity> {
    return (
      await User.aggregate([
        { $match: { _id: userId } },
        {
          $lookup: {
            from: GYM_COLLECTION_NAME,
            localField: "gymId",
            foreignField: "_id",
            as: "gym",
          },
        },
        {
          $project: {
            _id: -1,
            gym: 1,
          },
        },
      ])
    )[0].gym[0];
  }
}
