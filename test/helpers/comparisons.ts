import {
  IAddressEntity,
  IGymEntity,
  ILocationEntity,
  IUserEntity,
} from "../../src/entities";

export function compareGym(gym1: IGymEntity, doc: any) {
  expect(gym1.name).toBe(doc.name);
  compareLocation(gym1.location, doc.location);
  compareAddress(gym1.address, doc.address);
}

export function compareAddress(address: IAddressEntity, doc: any) {
  expect(address.street).toEqual(doc.street);
  expect(address.city).toEqual(doc.city);
  expect(address.state).toEqual(doc.state);
  expect(address.zipCode).toEqual(doc.zipCode);
}

export function compareLocation(location: ILocationEntity, doc: any) {
  expect(location.type).toBe("Point");
  expect(location.coordinates.length).toBe(2);
  expect(doc.type).toBe("Point");
  expect(doc.coordinates.length).toBe(2);
  expect(location.coordinates[0]).toBeCloseTo(doc.coordinates[0]);
  expect(location.coordinates[1]).toBeCloseTo(doc.coordinates[1]);
}

export function compareExploreUserData(
  user: Omit<IUserEntity, "email" | "gymId">,
  other: IUserEntity
) {
  expect(user.cognitoId).toEqual(other.cognitoId);
  expect(user.firstName).toEqual(other.firstName);
  expect(user.lastName).toEqual(other.lastName);
}

export function comparePublicUserData(
  user: Omit<IUserEntity, "email">,
  other: IUserEntity
) {
  expect(user.cognitoId).toEqual(other.cognitoId);
  expect(user.gymId).toEqual(other.gymId);
  expect(user.firstName).toEqual(other.firstName);
  expect(user.lastName).toEqual(other.lastName);
}

export function compareUserData(user: IUserEntity, doc: any) {
  expect(user.cognitoId).toEqual(doc.cognitoId);
  expect(user.email).toEqual(doc.email);
  expect(user.gymId).toEqual(doc.gymId);
  expect(user.firstName).toEqual(doc.firstName);
  expect(user.lastName).toEqual(doc.lastName);
}
