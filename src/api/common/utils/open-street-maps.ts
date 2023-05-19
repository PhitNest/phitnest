import axios from "axios";
import { IAddressEntity, ILocationEntity } from "../entities";

export async function getLocation(
  address: IAddressEntity
): Promise<ILocationEntity | null> {
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
    return {
      longitude: parseFloat(lon),
      latitude: parseFloat(lat),
    };
  }
  return null;
}
