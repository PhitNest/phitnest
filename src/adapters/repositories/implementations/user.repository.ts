import mongoose from "mongoose";
import { IGymEntity, IUserEntity } from "../../../domain/entities";
import { IUserRepository } from "../interfaces";

const schema = new mongoose.Schema(
  {
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

const User = mongoose.model<IUserEntity>("User", schema);

export class MongoUserRepository implements IUserRepository {
  async getGym(userId: string): Promise<IGymEntity> {
    return (
      await User.aggregate([
        { $match: { _id: userId } },
        {
          $lookup: {
            from: "gyms",
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
