import { Failure } from "../../common/types";
import { IGymEntity, IUserEntity, LocationEntity } from "../../entities";

export interface IGymRepository {
  create(gym: Omit<IGymEntity, "_id">): Promise<IGymEntity>;

  getNearest(
    location: LocationEntity,
    meters: number,
    amount?: number
  ): Promise<IGymEntity[]>;

  getByUser(user: IUserEntity): Promise<IGymEntity | Failure>;

  get(gymId: string): Promise<IGymEntity | Failure>;

  deleteAll(): Promise<void>;
}
