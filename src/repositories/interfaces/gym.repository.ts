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
  ): Promise<Either<typeof kGymNotFound, IGymEntity>>;

  get(gymId: string): Promise<Either<typeof kGymNotFound, IGymEntity>>;

  deleteAll(): Promise<void>;
}
