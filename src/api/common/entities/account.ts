import { Dynamo, DynamoShape } from "./dynamo";

export type CreationDetails = {
  id: string;
  createdAt: Date;
};

export const kCreationDetailsDynamo: DynamoShape<CreationDetails> = {
  id: "S",
  createdAt: "D",
};

export type Account = CreationDetails & {
  email: string;
};

export const kAccountDynamo: DynamoShape<Account> = {
  email: "S",
  ...kCreationDetailsDynamo,
};

export function accountToDynamo(account: Account): Dynamo<Account> {
  return {
    email: { S: account.email },
    ...creationDetailsToDynamo(account),
  };
}

export function creationDetailsToDynamo(
  account: CreationDetails
): Dynamo<CreationDetails> {
  return {
    id: { S: account.id },
    createdAt: { N: account.createdAt.getTime().toString() },
  };
}
