import { injectable } from "inversify";
import mongoose from "mongoose";
import { IGymEntity, ILocationEntity } from "../../entities";
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
  async get(userId: string): Promise<IGymEntity> {
    const res = (
      await UserModel.aggregate([
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
            gym: 1,
          },
        },
      ])
    )[0].gym[0];
    return {
      id: res._id,
      name: res.name,
      address: res.address,
      location: {
        longitude: res.location.coordinates[0],
        latitude: res.location.coordinates[1],
      },
    };
  }

  async getNearest(
    location: ILocationEntity,
    distance: number,
    amount?: number
  ): Promise<IGymEntity[]> {
    const gyms = await GymModel.aggregate([
      {
        $match: {
          location: {
            $near: {
              $maxDistance: distance,
              $geometry: {
                type: "Point",
                coordinates: [location.longitude, location.latitude],
              },
            },
          },
        },
      },
      {
        $limit: amount ?? 0,
      },
      {
        $project: {
          id: {
            _id: 1,
          },
          name: 1,
          address: 1,
          location: 1,
        },
      },
    ]);
    return gyms.map((gym) => {
      return {
        id: gym._id,
        name: gym.name,
        address: gym.address,
        location: {
          longitude: gym.location.coordinates[0],
          latitude: gym.location.coordinates[1],
        },
      };
    });
  }
}
