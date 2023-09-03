import { Admin, adminToDynamo, kAdminParser } from "../entities";
import { DynamoClient, ResourceNotFoundError, RowKey } from "../utils";

const kAdminPk = "ADMINS";
const kAdminSkPrefix = "ADMIN#";

export function adminSk(id: string) {
  return `${kAdminSkPrefix}${id}`;
}

export function adminKey(id: string): RowKey {
  return {
    pk: kAdminPk,
    sk: adminSk(id),
  };
}

export async function createAdmin(
  dynamo: DynamoClient,
  id: string,
  email: string,
): Promise<Admin> {
  const admin = {
    id: id,
    email: email,
    createdAt: new Date(),
  };
  await dynamo.put({
    ...adminKey(id),
    data: adminToDynamo(admin),
  });
  return admin;
}

export async function getAdmin(
  dynamo: DynamoClient,
  id: string,
): Promise<Admin | ResourceNotFoundError> {
  return await dynamo.parsedQuery({
    pk: kAdminPk,
    sk: { q: adminSk(id), op: "EQ" },
    parseShape: kAdminParser,
  });
}
