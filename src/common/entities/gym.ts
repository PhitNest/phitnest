import { Address, addressToDynamo, kAddressParser } from "./address";
import { SerializedDynamo, DynamoParser } from "./dynamo";
import { Location, kLocationParser, locationToDynamo } from "./location";

export type Gym = {
  id: string;
  gymName: string;
  address: Address;
  gymLocation: Location;
  createdAt: Date;
  adminEmail: string;
};

export const kGymParser: DynamoParser<Gym> = {
  id: "S",
  gymName: "S",
  address: kAddressParser,
  gymLocation: kLocationParser,
  createdAt: "D",
  adminEmail: "S",
};

export function gymToDynamo(gym: Gym): SerializedDynamo<Gym> {
  return {
    id: { S: gym.id },
    gymName: { S: gym.gymName },
    address: { M: addressToDynamo(gym.address) },
    gymLocation: { M: locationToDynamo(gym.gymLocation) },
    createdAt: { N: gym.createdAt.getTime().toString() },
    adminEmail: { S: gym.adminEmail },
  };
}
