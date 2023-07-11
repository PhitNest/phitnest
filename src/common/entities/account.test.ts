import {
  AccountDetails,
  CreationDetails,
  accountDetailsToDynamo,
  creationDetailsToDynamo,
  kAccountDetailsParser,
  kCreationDetailsParser,
} from "./account";
import { SerializedDynamo, parseDynamo } from "./dynamo";

const testCreationDetails: CreationDetails = {
  id: "1",
  createdAt: new Date(Date.UTC(2020, 1, 1)),
};

const testAccountDetails: AccountDetails = {
  email: "something",
  ...testCreationDetails,
};

const serializedCreationDetails: SerializedDynamo<CreationDetails> = {
  createdAt: { N: Date.UTC(2020, 1, 1).toString() },
  id: { S: "1" },
};

const serializedAccountDetails: SerializedDynamo<AccountDetails> = {
  email: { S: "something" },
  ...serializedCreationDetails,
};

describe("CreationDetails", () => {
  it("serializes to dynamo", () => {
    expect(creationDetailsToDynamo(testCreationDetails)).toEqual(
      serializedCreationDetails
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(serializedCreationDetails, kCreationDetailsParser)
    ).toEqual(testCreationDetails);
  });
});

describe("AccountDetails", () => {
  it("serializes to dynamo", () => {
    expect(accountDetailsToDynamo(testAccountDetails)).toEqual(
      serializedAccountDetails
    );
  });

  it("deserializes from dynamo", () => {
    expect(
      parseDynamo(serializedAccountDetails, kAccountDetailsParser)
    ).toEqual(testAccountDetails);
  });
});
