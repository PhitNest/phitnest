import { Gym, kGymParser } from "../entities";
import { DynamoClient, ResourceNotFoundError } from "../utils";

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
