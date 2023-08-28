import { Admin, adminToDynamo, kAdminParser } from "common/entities";
import { DynamoClient, ResourceNotFoundError } from "common/utils";

const kAdminPk = "ADMINS";
const kAdminSkPrefix = "ADMIN#";

export async function createAdmin(
  dynamo: DynamoClient,
  id: string,
  email: string
): Promise<Admin> {
  const admin = {
    id: id,
    email: email,
    createdAt: new Date(),
  };
  await dynamo.put({
    pk: kAdminPk,
    sk: `${kAdminSkPrefix}${id}`,
    data: adminToDynamo(admin),
  });
  return admin;
}

export async function getAdmin(
  dynamo: DynamoClient,
  id: string
): Promise<Admin | ResourceNotFoundError> {
  return await dynamo.parsedQuery({
    pk: kAdminPk,
    sk: { q: `${kAdminSkPrefix}${id}`, op: "EQ" },
    parseShape: kAdminParser,
  });
}
