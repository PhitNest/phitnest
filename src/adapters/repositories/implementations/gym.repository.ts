import mongoose from "mongoose";
import { IGymEntity, ILocationEntity } from "../../../domain/entities";
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

const Gym = mongoose.model<IGymEntity>(GYM_MODEL_NAME, schema);

export class MongoGymRepository implements IGymRepository {
  getNearestGyms(
    location: ILocationEntity,
    distance: number,
    amount: number
  ): Promise<IGymEntity[]> {
    const query = Gym.find({
      location: {
        $near: {
          $maxDistance: distance,
          $geometry: {
            type: "Point",
            coordinates: [location.longitude, location.latitude],
          },
        },
      },
    });

    if (amount > 0) {
      query.limit(amount);
    }
    return query.exec();
  }
}
