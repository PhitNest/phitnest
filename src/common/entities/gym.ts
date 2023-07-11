import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsParser,
} from "./account";
import { Address, addressToDynamo, kAddressParser } from "./address";
import { SerializedDynamo, DynamoParser } from "./dynamo";
import { Location, kLocationParser, locationToDynamo } from "./location";

export type GymWithoutAdmin = CreationDetails & {
  gymName: string;
  address: Address;
  gymLocation: Location;
};

export const kGymWithoutAdminParser: DynamoParser<GymWithoutAdmin> = {
  gymName: "S",
  address: kAddressParser,
  gymLocation: kLocationParser,
  ...kCreationDetailsParser,
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
    gymName: { S: gym.gymName },
    address: { M: addressToDynamo(gym.address) },
    gymLocation: { M: locationToDynamo(gym.gymLocation) },
    ...creationDetailsToDynamo(gym),
  };
}

export function gymToDynamo(gym: Gym): SerializedDynamo<Gym> {
  return {
    ...gymWithoutAdminToDynamo(gym),
    adminEmail: { S: gym.adminEmail },
  };
}
