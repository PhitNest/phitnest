import {
  Address,
  Gym,
  Location,
  gymToDynamo,
  kGymParser,
} from "common/entities";
import { DynamoClient, ResourceNotFoundError } from "common/utils";
import * as uuid from "uuid";

const kGymPk = "GYMS";
const kGymSkPrefix = "GYM#";

export function gymSk(id: string) {
  return `${kGymSkPrefix}${id}`;
}

export function gymKey(id: string) {
  return {
    pk: kGymPk,
    sk: gymSk(id),
  };
}

export async function createGymWithLocation(
  dynamo: DynamoClient,
  params: {
    adminEmail: string;
    name: string;
    address: Address;
    location: Location;
  },
): Promise<Gym> {
  const gym = {
    id: uuid.v4(),
    gymName: params.name,
    address: params.address,
    adminEmail: params.adminEmail,
    createdAt: new Date(),
    gymLocation: params.location,
  };
  await dynamo.put({
    ...gymKey(gym.id),
    data: gymToDynamo(gym),
  });
  return gym;
}

export async function getGym(
  dynamo: DynamoClient,
  id: string,
): Promise<Gym | ResourceNotFoundError> {
  return await dynamo.parsedQuery({
    pk: kGymPk,
    sk: { q: gymSk(id), op: "EQ" },
    parseShape: kGymParser,
  });
}

export async function getGyms(dynamo: DynamoClient): Promise<Gym[]> {
  return await dynamo.parsedQuery({
    pk: kGymPk,
    sk: { q: kGymSkPrefix, op: "BEGINS_WITH" },
    parseShape: kGymParser,
  });
}
