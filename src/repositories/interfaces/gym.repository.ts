import { IAddressEntity, IGymEntity, ILocationEntity } from "../../entities";

export interface IGymRepository {
  create(
    name: string,
    address: IAddressEntity,
    location: ILocationEntity
  ): Promise<IGymEntity>;
  getNearest(
    location: ILocationEntity,
    meters: number,
    amount?: number
  ): Promise<IGymEntity[]>;
  get(cognitoId: string): Promise<IGymEntity>;
}
