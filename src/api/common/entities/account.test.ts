import { Account, accountToDynamo, kAccountDynamo } from "./account";
import { Dynamo, parseDynamo } from "./dynamo";

const testAccount: Account = {
  email: "something",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
  id: "1",
};

const serializedAccount: Dynamo<Account> = {
  email: { S: "something" },
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  id: { S: "1" },
};

describe("Account", () => {
  it("serializes to dynamo", () => {
    expect(accountToDynamo(testAccount)).toEqual(serializedAccount);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedAccount, kAccountDynamo)).toEqual(testAccount);
  });
});
