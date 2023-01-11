import {
  IFriendRequestEntity,
  IFriendshipEntity,
  IGymEntity,
  IUserEntity,
} from "../../src/entities";

export function compareGyms(left: IGymEntity, right: IGymEntity) {
  expect(left._id).toEqual(right._id);
  expect(left.name).toBe(right.name);
  expect(left.location).toEqual(right.location);
  expect(left.address).toEqual(right.address);
}

export function compareUsers(left: IUserEntity, right: IUserEntity) {
  expect(left._id).toEqual(right._id);
  expect(left.firstName).toBe(right.firstName);
  expect(left.lastName).toBe(right.lastName);
  expect(left.email).toBe(right.email);
  expect(left.gymId).toEqual(right.gymId);
  expect(left.cognitoId).toBe(right.cognitoId);
  expect(left.confirmed).toBe(right.confirmed);
}

export function compareFriendRequests(
  left: IFriendRequestEntity,
  right: IFriendRequestEntity
) {
  expect(left._id).toEqual(right._id);
  expect(left.fromCognitoId).toEqual(right.fromCognitoId);
  expect(left.toCognitoId).toEqual(right.toCognitoId);
  expect(left.createdAt).toEqual(right.createdAt);
}

export function compareFriendships(
  left: IFriendshipEntity,
  right: IFriendshipEntity
) {
  expect(left._id).toEqual(right._id);
  expect(left.userCognitoIds).toEqual(right.userCognitoIds);
  expect(left.createdAt).toEqual(right.createdAt);
}
