import { IAddressEntity, ILocationEntity } from "../../entities";

export interface ILocationRepository {
  get(address: IAddressEntity): Promise<ILocationEntity | null>;
}
