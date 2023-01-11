import { Either } from "typescript-monads";
import { kGymNotFound } from "../../common/failures";
import { IGymEntity, IUserEntity, LocationEntity } from "../../entities";

export interface IGymRepository {
  create(gym: Omit<IGymEntity, "_id">): Promise<IGymEntity>;

  getNearest(
    location: LocationEntity,
    meters: number,
    amount?: number
  ): Promise<IGymEntity[]>;

  getByUser(
    user: IUserEntity
  ): Promise<Either<IGymEntity, typeof kGymNotFound>>;

  get(gymId: string): Promise<Either<IGymEntity, typeof kGymNotFound>>;

  deleteAll(): Promise<void>;
}
