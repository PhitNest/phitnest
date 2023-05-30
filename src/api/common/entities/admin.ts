import { Account, accountToDynamo, kAccountDynamo } from "./account";
import { Dynamo, DynamoShape } from "./dynamo";

export type Admin = {
  accountDetails: Account;
};

export const kAdminDynamo: DynamoShape<Admin> = {
  accountDetails: kAccountDynamo,
};

export function adminToDynamo(admin: Admin): Dynamo<Admin> {
  return {
    accountDetails: { M: accountToDynamo(admin.accountDetails) },
  };
}
