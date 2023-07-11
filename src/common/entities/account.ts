import { SerializedDynamo, DynamoParser } from "./dynamo";

export type CreationDetails = {
  id: string;
  createdAt: Date;
};

export const kCreationDetailsParser: DynamoParser<CreationDetails> = {
  id: "S",
  createdAt: "D",
};

export type AccountDetails = CreationDetails & {
  email: string;
};

export const kAccountDetailsParser: DynamoParser<AccountDetails> = {
  email: "S",
  ...kCreationDetailsParser,
};

export function accountDetailsToDynamo(
  accountDetails: AccountDetails
): SerializedDynamo<AccountDetails> {
  return {
    email: { S: accountDetails.email },
    ...creationDetailsToDynamo(accountDetails),
  };
}

export function creationDetailsToDynamo(
  account: CreationDetails
): SerializedDynamo<CreationDetails> {
  return {
    id: { S: account.id },
    createdAt: { N: account.createdAt.getTime().toString() },
  };
}
