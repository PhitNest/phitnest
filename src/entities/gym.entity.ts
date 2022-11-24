import { IAddressEntity } from "./address.entity";
import { ILocationEntity } from "./location.entity";

export interface IGymEntity {
  id: string;
  name: string;
  address: IAddressEntity;
  location: ILocationEntity;
}
