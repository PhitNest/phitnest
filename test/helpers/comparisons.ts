import {
  IDirectMessageEntity,
  IFriendRequestEntity,
  IFriendshipEntity,
  IGymEntity,
  IProfilePicturePublicUserEntity,
  IProfilePictureUserEntity,
  IPublicUserEntity,
  IUserEntity,
} from "../../src/entities";

export function compareGyms(left: IGymEntity, right: IGymEntity) {
  expect(left._id).toEqual(right._id);
  expect(left.name).toBe(right.name);
  expect(left.location).toEqual(right.location);
  expect(left.address).toEqual(right.address);
}

export function compareUsers(left: IUserEntity, right: IUserEntity) {
  expect(left.email).toBe(right.email);
  expect(left.confirmed).toBe(right.confirmed);
  comparePublicUsers(left, right);
}

export function comparePublicUsers(
  left: IPublicUserEntity,
  right: IPublicUserEntity
) {
  expect(left._id).toEqual(right._id);
  expect(left.firstName).toBe(right.firstName);
  expect(left.lastName).toBe(right.lastName);
  expect(left.gymId).toEqual(right.gymId);
  expect(left.cognitoId).toBe(right.cognitoId);
}

export function compareFriendRequests(
  left: IFriendRequestEntity,
  right: IFriendRequestEntity
) {
  expect(left._id).toEqual(right._id);
  expect(left.fromCognitoId).toEqual(right.fromCognitoId);
  expect(left.toCognitoId).toEqual(right.toCognitoId);
  expect(left.createdAt).toEqual(right.createdAt);
  expect(left.denied).toBe(right.denied);
}

export function compareFriendships(
  left: IFriendshipEntity,
  right: IFriendshipEntity
) {
  expect(left._id).toEqual(right._id);
  expect(left.userCognitoIds).toEqual(right.userCognitoIds);
  expect(left.createdAt).toEqual(right.createdAt);
}

export function compareDirectMessages(
  left: IDirectMessageEntity,
  right: IDirectMessageEntity
) {
  expect(left._id).toEqual(right._id);
  expect(left.friendshipId).toEqual(right.friendshipId);
  expect(left.senderCognitoId).toEqual(right.senderCognitoId);
  expect(left.text).toEqual(right.text);
  expect(left.createdAt).toEqual(right.createdAt);
}

export function compareProfilePicturePublicUsers(
  left: IProfilePicturePublicUserEntity,
  right: IProfilePicturePublicUserEntity
) {
  comparePublicUsers(left, right);
  expect(left.profilePictureUrl).toEqual(right.profilePictureUrl);
}

export function compareProfilePictureUsers(
  left: IProfilePictureUserEntity,
  right: IProfilePictureUserEntity
) {
  compareUsers(left, right);
  expect(left.profilePictureUrl).toEqual(right.profilePictureUrl);
}
