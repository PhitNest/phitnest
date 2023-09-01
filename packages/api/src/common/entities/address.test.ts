import { Address, addressToDynamo, kAddressParser } from "./address";
import { SerializedDynamo, parseDynamo } from "./dynamo";

const kTestAddress: Address = {
  city: "city",
  state: "state",
  street: "street",
  zipCode: "zip",
};

const kSerializedAddress: SerializedDynamo<Address> = {
  city: { S: "city" },
  state: { S: "state" },
  street: { S: "street" },
  zipCode: { S: "zip" },
};

describe("Address", () => {
  it("serializes to dynamo", () => {
    expect(addressToDynamo(kTestAddress)).toEqual(kSerializedAddress);
  });

  it("deserializes from dynamo", () => {
    expect(parseDynamo(kSerializedAddress, kAddressParser)).toEqual(
      kTestAddress,
    );
  });
});
