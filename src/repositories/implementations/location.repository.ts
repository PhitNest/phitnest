import { IAddressEntity, LocationEntity } from "../../entities";
import { ILocationRepository } from "../interfaces/location.repository";
import { kLocationNotFound } from "../../common/failures";
import { Either } from "typescript-monads";

export class OSMLocationRepository implements ILocationRepository {
  async get(address: IAddressEntity) {
    const response = await fetch(
      `https://nominatim.openstreetmap.org/search?q=${address.street},+${address.city},+${address.state}+${address.zipCode}&format=json&polygon=1&addressdetails=1`,
      {
        method: "GET",
      }
    );
    const data = await response.json();
    if (data && data.length > 0) {
      const { lon, lat } = data[0];
      const location = new LocationEntity(parseFloat(lon), parseFloat(lat));
      return new Either<typeof kLocationNotFound, LocationEntity>(location);
    }
    return new Either<typeof kLocationNotFound, LocationEntity>(
      undefined,
      kLocationNotFound
    );
  }
}
