import { Failure } from "../../../common/types";
import { IAddressEntity, LocationEntity } from "../../../domain/entities";

export interface ILocationDatabase {
  get(address: IAddressEntity): Promise<LocationEntity | Failure>;
}
