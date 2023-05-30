import {
  CreationDetails,
  creationDetailsToDynamo,
  kCreationDetailsDynamo,
} from "./account";
import { Address, addressToDynamo, kAddressDynamo } from "./address";
import { Admin, adminToDynamo, kAdminDynamo } from "./admin";
import { Dynamo, DynamoShape } from "./dynamo";

export type GymWithoutAdmin = CreationDetails & {
  name: string;
  address: Address;
};

export const kGymWithoutAdminDynamo: DynamoShape<GymWithoutAdmin> = {
  name: "S",
  address: kAddressDynamo,
  ...kCreationDetailsDynamo,
};

export type Gym = GymWithoutAdmin & {
  admin: Admin;
};

export const kGymDynamo: DynamoShape<Gym> = {
  ...kGymWithoutAdminDynamo,
  admin: kAdminDynamo,
};

export function gymWithoutAdminToDynamo(
  gym: GymWithoutAdmin
): Dynamo<GymWithoutAdmin> {
  return {
    name: { S: gym.name },
    address: { M: addressToDynamo(gym.address) },
    ...creationDetailsToDynamo(gym),
  };
}

export function gymToDynamo(gym: Gym): Dynamo<Gym> {
  return {
    ...gymWithoutAdminToDynamo(gym),
    admin: { M: adminToDynamo(gym.admin) },
  };
}
