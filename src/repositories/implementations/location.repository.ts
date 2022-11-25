import { IAddressEntity, ILocationEntity } from "../../entities";
import axios from "axios";
import { ILocationRepository } from "../interfaces/location.repository";
import { injectable } from "inversify";

@injectable()
export class OSMLocationRepository implements ILocationRepository {
  async get(address: IAddressEntity) {
    const response = await axios.get(
      "https://nominatim.openstreetmap.org/search",
      {
        params: {
          q: `${address.street}, ${address.city}, ${address.state} ${address.zipCode}`.replace(
            /%20/g,
            "+"
          ),
          format: "json",
          polygon: 1,
          addressdetails: 1,
        },
      }
    );
    if (response.data && response.data.length > 0) {
      const { lon, lat } = response.data[0];
      const location: ILocationEntity = {
        type: "Point",
        coordinates: [parseFloat(lon), parseFloat(lat)],
      };
      return location;
    }
    return null;
  }
}
