import { kGymNotFound } from "../../../common/failures";
import { IGymEntity, LocationEntity } from "../../../domain/entities";
import { GymModel } from "../../mongo";
import { IGymDatabase } from "../interfaces";

export class MongoGymDatabase implements IGymDatabase {
  async deleteAll() {
    await GymModel.deleteMany({});
  }

  async create(gym: Omit<IGymEntity, "_id">) {
    return (await GymModel.create(gym)).toObject();
  }

  async getNearest(location: LocationEntity, meters: number, amount?: number) {
    if (amount != 0) {
      return (
        await GymModel.find({
          location: {
            $near: {
              $maxDistance: meters,
              $geometry: location,
            },
          },
        }).limit(amount ?? 0)
      ).map((gym) => gym.toObject());
    } else {
      return [];
    }
  }

  async get(gymId: string) {
    const gym = await GymModel.findById(gymId);
    if (gym) {
      return gym.toObject();
    } else {
      return kGymNotFound;
    }
  }
}
