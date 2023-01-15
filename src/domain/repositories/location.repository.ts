import { IAddressEntity } from "../entities";
import dataSources from "../../data/data-sources/injection";

class LocationRepository {
  get(address: IAddressEntity) {
    return dataSources().locationDatabase.get(address);
  }
}

export const locationRepo = new LocationRepository();
