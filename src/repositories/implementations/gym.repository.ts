import { injectable } from "inversify";
import mongoose from "mongoose";
import { IGymEntity, LocationEntity } from "../../entities";
import { IGymRepository } from "../interfaces";
import { UserModel } from "./user.repository";

export const GYM_COLLECTION_NAME = "gyms";
export const GYM_MODEL_NAME = "Gym";

const schema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    address: {
      street: { type: String, required: true, trim: true },
      city: { type: String, required: true, trim: true },
      state: { type: String, required: true, trim: true },
      zipCode: { type: String, required: true, trim: true },
    },
    location: {
      type: { type: String },
      coordinates: [Number],
    },
  },
  {
    collection: GYM_COLLECTION_NAME,
  }
);

schema.index({ location: "2dsphere" });

export const GymModel = mongoose.model<IGymEntity>(GYM_MODEL_NAME, schema);

@injectable()
export class MongoGymRepository implements IGymRepository {
  async deleteAll() {
    await GymModel.deleteMany({}).exec();
  }

  create(gym: Omit<IGymEntity, "_id">) {
    return GymModel.create(gym);
  }

  async getByUser(cognitoId: string) {
    const results = await UserModel.aggregate([
      {
        $match: { cognitoId: cognitoId },
      },
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
          gym: 1,
        },
      },
    ]);
    if (results.length > 0) {
      return results[0].gym[0];
    } else {
      return null;
    }
  }

  async getNearest(location: LocationEntity, meters: number, amount?: number) {
    if (amount != 0) {
      const query = GymModel.find({
        location: {
          $near: {
            $maxDistance: meters,
            $geometry: location,
          },
        },
      }).limit(amount ?? 0);
      return await query.exec();
    } else {
      return [];
    }
  }

  async get(gymId: string) {
    return GymModel.findById(gymId);
  }
}
