import { SerializedDynamo, DynamoParser } from "./dynamo";

export type Address = {
  street: string;
  city: string;
  state: string;
  zipCode: string;
};

export const kAddressParser: DynamoParser<Address> = {
  street: "S",
  city: "S",
  state: "S",
  zipCode: "S",
};

export function addressToDynamo(address: Address): SerializedDynamo<Address> {
  return {
    street: { S: address.street },
    city: { S: address.city },
    state: { S: address.state },
    zipCode: { S: address.zipCode },
  };
}
