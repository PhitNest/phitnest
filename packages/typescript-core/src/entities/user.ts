import { SerializedDynamo, DynamoParser } from "./dynamo";

/**
 * Represents a user on the "explore" page of the mobile app.
 */
export type UserExplore = {
  id: string;
  firstName: string;
  lastName: string;
  createdAt: Date;
  identityId: string;
};

export const kUserExploreParser: DynamoParser<UserExplore> = {
  id: "S",
  firstName: "S",
  lastName: "S",
  createdAt: "D",
  identityId: "S",
};

/**
 * Represents a user who does not have an identity ID registered with Cognito yet.
 * This does contain sensitive user information (email)
 */
export type UserWithoutIdentity = {
  id: string;
  firstName: string;
  lastName: string;
  createdAt: Date;
  email: string;
};

export const kUserWithoutIdentityParser: DynamoParser<UserWithoutIdentity> = {
  id: "S",
  firstName: "S",
  lastName: "S",
  createdAt: "D",
  email: "S",
};

export type User = UserWithoutIdentity & {
  identityId: string;
};

export const kUserParser: DynamoParser<User> = {
  ...kUserWithoutIdentityParser,
  identityId: "S",
};

export function userWithoutIdentityToDynamo(
  user: UserWithoutIdentity
): SerializedDynamo<UserWithoutIdentity> {
  return {
    id: { S: user.id },
    firstName: { S: user.firstName },
    lastName: { S: user.lastName },
    createdAt: { N: user.createdAt.getTime().toString() },
    email: { S: user.email },
  };
}

export function userExploreToDynamo(
  userExplore: UserExplore
): SerializedDynamo<UserExplore> {
  return {
    id: { S: userExplore.id },
    firstName: { S: userExplore.firstName },
    lastName: { S: userExplore.lastName },
    createdAt: { N: userExplore.createdAt.getTime().toString() },
    identityId: { S: userExplore.identityId },
  };
}

export function userToDynamo(user: User): SerializedDynamo<User> {
  return {
    ...userWithoutIdentityToDynamo(user),
    identityId: { S: user.identityId },
  };
}
