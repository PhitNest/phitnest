import { Either } from "typescript-monads";
import { kGymNotFound } from "../../common/failures";
import { IGymEntity, IUserEntity, LocationEntity } from "../../entities";
import { GymModel } from "../../mongo";
import { IGymRepository } from "../interfaces";

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
      return GymModel.find({
        location: {
          $near: {
            $maxDistance: meters,
            $geometry: location,
          },
        },
      })
        .limit(amount ?? 0)
        .exec();
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
