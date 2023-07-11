import {
  AccountDetails,
  accountDetailsToDynamo,
  kAccountDetailsParser,
} from "./account";
import { SerializedDynamo, DynamoParser } from "./dynamo";

export type Admin = AccountDetails;

export const kAdminParser: DynamoParser<Admin> = kAccountDetailsParser;

export function adminToDynamo(admin: Admin): SerializedDynamo<Admin> {
  return accountDetailsToDynamo(admin);
}
