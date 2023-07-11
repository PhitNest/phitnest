import axios from "axios";
import { Address, Location } from "../entities";
import { RequestError } from "./request-handling";

export const kOpenStreetMapErrorType = "OPEN_STREET_MAP_ERROR";

export class OpenStreetMapError extends RequestError {
  constructor() {
    super(kOpenStreetMapErrorType, "Could not find location.");
  }
}

/**
 * Gets the longitude and latitude of an address.
 *
 * @param address The address to get the location of.
 * @returns The longitude and latitude of the address, or an OpenStreetMapError if the address could not be found.
 */
export async function getLocation(
  address: Address
): Promise<Location | OpenStreetMapError> {
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
  return new OpenStreetMapError();
}
