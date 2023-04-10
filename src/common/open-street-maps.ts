import { Point } from "../generated/dgraph-schema";
import { kLocationNotFound } from "./failures";
import { Failure } from "./failures";
import fetch from "isomorphic-fetch";

export async function getLocation(address: {
  street: string;
  city: string;
  state: string;
  zipCode: string;
}): Promise<Point | Failure> {
  try {
    const response = await fetch(
      `https://nominatim.openstreetmap.org/search?q=${address.street},+${address.city},+${address.state}+${address.zipCode}&format=json&polygon=1&addressdetails=1`,
      {
        method: "GET",
      }
    );
    const data = (await response.json()) as { lon: string; lat: string }[];
    if (data && data.length > 0) {
      const { lon, lat } = data[0];
      return {
        __typename: "Point",
        longitude: parseFloat(lon),
        latitude: parseFloat(lat),
      };
    }
    return kLocationNotFound;
  } catch (err) {
    return kLocationNotFound;
  }
}
