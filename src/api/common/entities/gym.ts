import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsDynamo,
} from "./account";
import { Address, addressToDynamo, kAddressDynamo } from "./address";
import { Dynamo, DynamoShape } from "./dynamo";
import { Location, kLocationDynamo, locationToDynamo } from "./location";

export type GymWithoutAdmin = CreationDetails & {
  gymName: string;
  address: Address;
  location: Location;
};

export const kGymWithoutAdminDynamo: DynamoShape<GymWithoutAdmin> = {
  gymName: "S",
  address: kAddressDynamo,
  location: kLocationDynamo,
  ...kCreationDetailsDynamo,
};

export type Gym = GymWithoutAdmin & {
  adminEmail: string;
};

export const kGymDynamo: DynamoShape<Gym> = {
  ...kGymWithoutAdminDynamo,
  adminEmail: "S",
};

export function gymWithoutAdminToDynamo(
  gym: GymWithoutAdmin
): Dynamo<GymWithoutAdmin> {
  return {
    gymName: { S: gym.gymName },
    address: { M: addressToDynamo(gym.address) },
    location: { M: locationToDynamo(gym.location) },
    ...creationDetailsToDynamo(gym),
  };
}

export function gymToDynamo(gym: Gym): Dynamo<Gym> {
  return {
    ...gymWithoutAdminToDynamo(gym),
    adminEmail: { S: gym.adminEmail },
  };
}
