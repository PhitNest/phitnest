import { IAddressEntity, LocationEntity } from "../../entities";

export interface ILocationRepository {
  get(address: IAddressEntity): Promise<LocationEntity | null>;
}
