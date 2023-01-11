import mongoose from "mongoose";
import { Either } from "typescript-monads";
import { kGymNotFound } from "../../common/failures";
import { IGymEntity, IUserEntity, LocationEntity } from "../../entities";
import { IGymRepository } from "../interfaces";

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

const GymModel = mongoose.model<IGymEntity>(GYM_MODEL_NAME, schema);

export class MongoGymRepository implements IGymRepository {
  async getByUser(user: IUserEntity) {
    const gym = await GymModel.findById(user.gymId);
    if (gym) {
      return new Either<IGymEntity, typeof kGymNotFound>(gym);
    } else {
      return new Either<IGymEntity, typeof kGymNotFound>(
        undefined,
        kGymNotFound
      );
    }
  }

  async deleteAll() {
    await GymModel.deleteMany({}).exec();
  }

  create(gym: Omit<IGymEntity, "_id">) {
    return GymModel.create(gym);
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
    const gym = await GymModel.findById(gymId);
    if (gym) {
      return new Either<IGymEntity, typeof kGymNotFound>(gym);
    } else {
      return new Either<IGymEntity, typeof kGymNotFound>(
        undefined,
        kGymNotFound
      );
    }
  }
}
