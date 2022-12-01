import { IAddressEntity, IGymEntity, ILocationEntity } from "../../entities";

export interface IGymRepository {
  create(gym: Omit<IGymEntity, "_id">): Promise<IGymEntity>;
  getNearest(
    location: ILocationEntity,
    meters: number,
    amount?: number
  ): Promise<IGymEntity[]>;
  getByUser(cognitoId: string): Promise<IGymEntity | null>;
  get(gymId: string): Promise<IGymEntity | null>;
}
