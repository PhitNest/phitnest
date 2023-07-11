import { Address, addressToDynamo, kAddressParser } from "./address";
import { SerializedDynamo, parseDynamo } from "./dynamo";

const testAddress: Address = {
  city: "city",
  state: "state",
  street: "street",
  zipCode: "zip",
};

const serializedAddress: SerializedDynamo<Address> = {
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
    expect(parseDynamo(serializedAddress, kAddressParser)).toEqual(testAddress);
  });
});
