import { IAddressEntity } from "./address.entity";
import { LocationEntity } from "./location.entity";

export interface IGymEntity {
  _id: string;
  name: string;
  address: IAddressEntity;
  location: LocationEntity;
}
