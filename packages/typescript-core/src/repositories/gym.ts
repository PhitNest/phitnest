import { Address, Gym, Location, gymToDynamo, kGymParser } from "../entities";
import { DynamoClient, ResourceNotFoundError } from "../utils";
import * as uuid from "uuid";

const kGymPk = "GYM";
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

export async function createGym(
  dynamo: DynamoClient,
  params: {
    adminFirstName: string;
    adminLastName: string;
    adminEmail: string;
    gymName: string;
    address: Address;
    gymLocation: Location;
  },
): Promise<Gym> {
  const gym = {
    ...params,
    id: uuid.v4(),
    createdAt: new Date(),
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
