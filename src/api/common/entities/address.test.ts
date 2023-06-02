import { Address, addressToDynamo, kAddressDynamo } from "./address";
import { Dynamo, parseDynamo } from "./dynamo";

const testAddress: Address = {
  city: "city",
  state: "state",
  street: "street",
  zipCode: "zip",
};

const serializedAddress: Dynamo<Address> = {
  city: { S: "city" },
  state: { S: "state" },
  street: { S: "street" },
  zipCode: { S: "zip" },
};

describe("Address", () => {
  it("serializes to dynamo", () => {
    expect(addressToDynamo(testAddress)).toEqual(serializedAddress);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(serializedAddress, kAddressDynamo)).toEqual(testAddress);
  });
});
