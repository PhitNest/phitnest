import { SerializedDynamo, DynamoParser } from "./dynamo";

export interface Location {
  latitude: number;
  longitude: number;
}

export const kLocationParser: DynamoParser<Location> = {
  latitude: "N",
  longitude: "N",
};

export function locationToDynamo(
  location: Location
): SerializedDynamo<Location> {
  return {
    latitude: {
      N: location.latitude.toString(),
    },
    longitude: {
      N: location.longitude.toString(),
    },
  };
}
