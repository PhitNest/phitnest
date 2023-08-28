import { Address, Gym } from "common/entities";
import { createGymWithLocation, getLocation } from "common/repository";
import { DynamoClient, RequestError } from "common/utils";

export async function createGym(
  dynamo: DynamoClient,
  params: {
    adminEmail: string;
    name: string;
    address: Address;
  }
): Promise<Gym | RequestError> {
  const location = await getLocation(params.address);
  if (location instanceof RequestError) {
    return location;
  }
  return await createGymWithLocation(dynamo, {
    ...params,
    location: location,
  });
}
