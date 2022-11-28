import { IAddressEntity, IGymEntity, ILocationEntity } from "../../entities";

export interface IGymRepository {
  create(gym: Omit<IGymEntity, "_id">): Promise<IGymEntity>;
  getNearest(
    location: ILocationEntity,
    meters: number,
    amount?: number
  ): Promise<IGymEntity[]>;
  get(cognitoId: string): Promise<IGymEntity | null>;
}
