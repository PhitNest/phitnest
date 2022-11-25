import {
  IAddressEntity,
  ILocationEntity,
  IUserEntity,
} from "../../src/entities";

export function compareAddress(address: IAddressEntity, doc: any) {
  expect(address.street).toEqual(doc.street);
  expect(address.city).toEqual(doc.city);
  expect(address.state).toEqual(doc.state);
  expect(address.zipCode).toEqual(doc.zipCode);
}

export function compareLocation(location: ILocationEntity, doc: any) {
  expect(location.coordinates).toEqual(doc.coordinates);
}

export function comparePublicUserData(
  user: Partial<IUserEntity>,
  other: Omit<IUserEntity, "email">
) {
  expect(user.cognitoId).toEqual(other.cognitoId);
  expect(user.gymId).toEqual(other.gymId);
  expect(user.firstName).toEqual(other.firstName);
  expect(user.lastName).toEqual(other.lastName);
}
