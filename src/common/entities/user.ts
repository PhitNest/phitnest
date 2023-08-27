import { SerializedDynamo, DynamoParser } from "./dynamo";
import { Invite, inviteToDynamo, kInviteParser } from "./invite";

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

export type UserWithoutIdentity = {
  id: string;
  firstName: string;
  lastName: string;
  createdAt: Date;
  email: string;
  invite: Invite;
  numInvites: number;
};

export const kUserWithoutIdentityParser: DynamoParser<UserWithoutIdentity> = {
  id: "S",
  firstName: "S",
  lastName: "S",
  createdAt: "D",
  email: "S",
  numInvites: "N",
  invite: kInviteParser,
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
    numInvites: { N: user.numInvites.toString() },
    invite: { M: inviteToDynamo(user.invite) },
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
