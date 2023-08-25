import { Address, addressToDynamo, kAddressParser } from "./address";
import { SerializedDynamo, DynamoParser } from "./dynamo";
import { Location, kLocationParser, locationToDynamo } from "./location";

export type GymWithoutAdmin = {
  id: string;
  gymName: string;
  address: Address;
  gymLocation: Location;
  createdAt: Date;
};

export const kGymWithoutAdminParser: DynamoParser<GymWithoutAdmin> = {
  id: "S",
  gymName: "S",
  address: kAddressParser,
  gymLocation: kLocationParser,
  createdAt: "D",
};

export type Gym = GymWithoutAdmin & {
  adminEmail: string;
};

export const kGymParser: DynamoParser<Gym> = {
  ...kGymWithoutAdminParser,
  adminEmail: "S",
};

export function gymWithoutAdminToDynamo(
  gym: GymWithoutAdmin
): SerializedDynamo<GymWithoutAdmin> {
  return {
    id: { S: gym.id },
    gymName: { S: gym.gymName },
    address: { M: addressToDynamo(gym.address) },
    gymLocation: { M: locationToDynamo(gym.gymLocation) },
    createdAt: { N: gym.createdAt.getTime().toString() },
  };
}

export function gymToDynamo(gym: Gym): SerializedDynamo<Gym> {
  return {
    ...gymWithoutAdminToDynamo(gym),
    adminEmail: { S: gym.adminEmail },
  };
}
