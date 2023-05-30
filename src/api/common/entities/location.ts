import { Dynamo, DynamoShape } from "./dynamo";

export interface Location {
  latitude: number;
  longitude: number;
}

export const kLocationDynamo: DynamoShape<Location> = {
  latitude: "N",
  longitude: "N",
};

export function locationToDynamo(location: Location): Dynamo<Location> {
  return {
    latitude: {
      N: location.latitude.toString(),
    },
    longitude: {
      N: location.longitude.toString(),
    },
  };
}
