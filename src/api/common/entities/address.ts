import { Dynamo, DynamoShape } from "./dynamo";

export type Address = {
  street: string;
  city: string;
  state: string;
  zipCode: string;
};

export const kAddressDynamo: DynamoShape<Address> = {
  street: "S",
  city: "S",
  state: "S",
  zipCode: "S",
};

export function addressToDynamo(address: Address): Dynamo<Address> {
  return {
    street: { S: address.street },
    city: { S: address.city },
    state: { S: address.state },
    zipCode: { S: address.zipCode },
  };
}
