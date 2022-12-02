import {
  IAddressEntity,
  IGymEntity,
  LocationEntity,
  IPublicUserEntity,
  IUserEntity,
} from "../../src/entities";

export function compareGym(gym1: IGymEntity, ref: Omit<IGymEntity, "_id">) {
  expect(gym1.name).toBe(ref.name);
  compareLocation(gym1.location, ref.location);
  compareAddress(gym1.address, ref.address);
}

export function compareAddress(
  address1: IAddressEntity,
  address2: IAddressEntity
) {
  expect(address1.street).toEqual(address2.street);
  expect(address1.city).toEqual(address2.city);
  expect(address1.state).toEqual(address2.state);
  expect(address1.zipCode).toEqual(address2.zipCode);
}

export function compareLocation(loc1: LocationEntity, loc2: LocationEntity) {
  expect(loc1.coordinates.length).toBe(2);
  expect(loc2.coordinates.length).toBe(2);
  expect(loc1.coordinates[0]).toBeCloseTo(loc2.coordinates[0]);
  expect(loc1.coordinates[1]).toBeCloseTo(loc2.coordinates[1]);
}

export function compareExploreUserData(
  user: Omit<IPublicUserEntity, "gymId">,
  other: IUserEntity
) {
  expect(user.cognitoId).toEqual(other.cognitoId);
  expect(user.firstName).toEqual(other.firstName);
  expect(user.lastName).toEqual(other.lastName);
}

export function comparePublicUserData(
  user: IPublicUserEntity,
  other: IUserEntity
) {
  expect(user.cognitoId).toEqual(other.cognitoId);
  expect(user.gymId).toEqual(other.gymId);
  expect(user.firstName).toEqual(other.firstName);
  expect(user.lastName).toEqual(other.lastName);
}

export function compareUserData(
  user: IUserEntity,
  ref: Omit<IUserEntity, "_id">
) {
  expect(user.cognitoId).toEqual(ref.cognitoId);
  expect(user.email).toEqual(ref.email);
  expect(user.gymId).toEqual(ref.gymId);
  expect(user.firstName).toEqual(ref.firstName);
  expect(user.lastName).toEqual(ref.lastName);
}
