import { Failure } from "../../../../common/types";
import { IGymEntity, LocationEntity } from "../../../../domain/entities";

export interface IGymDatabase {
  create(gym: Omit<IGymEntity, "_id">): Promise<IGymEntity>;

  getNearest(
    location: LocationEntity,
    meters: number,
    amount?: number
  ): Promise<IGymEntity[]>;

  get(gymId: string): Promise<IGymEntity | Failure>;

  deleteAll(): Promise<void>;
}
