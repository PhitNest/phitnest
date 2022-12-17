import { IGymEntity, LocationEntity } from "../../entities";

export interface IGymRepository {
  create(gym: Omit<IGymEntity, "_id">): Promise<IGymEntity>;

  getNearest(
    location: LocationEntity,
    meters: number,
    amount?: number
  ): Promise<IGymEntity[]>;

  getByUser(cognitoId: string): Promise<IGymEntity | null>;

  get(gymId: string): Promise<IGymEntity | null>;

  deleteAll(): Promise<void>;
}
