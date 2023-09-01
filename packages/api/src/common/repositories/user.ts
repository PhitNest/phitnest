import {
  Invite,
  User,
  UserExplore,
  UserWithoutIdentity,
  kUserExploreParser,
  kUserParser,
  kUserWithoutIdentityParser,
  userWithoutIdentityToDynamo,
} from "common/entities";
import { DynamoParser } from "common/entities/dynamo";
import { DynamoClient, ResourceNotFoundError, RowKey } from "common/utils";

const kUserPkPrefix = "USER#";
const kNewUserSkPrefix = "NEW#";
const kUserSkPrefix = "GYM#";

export function userPk(id: string) {
  return `${kUserPkPrefix}${id}`;
}

export function userSk(gymId: string) {
  return `${kUserSkPrefix}${gymId}`;
}

export function newUserSk(id: string) {
  return `${kNewUserSkPrefix}${id}`;
}

export function newUserKey(id: string): RowKey {
  return {
    pk: userPk(id),
    sk: newUserSk(id),
  };
}

export function userKey(id: string, gymId: string): RowKey {
  return {
    pk: userPk(id),
    sk: userSk(gymId),
  };
}

async function getUserHelper<UserType extends UserExplore>(
  dynamo: DynamoClient,
  id: string,
  parser: DynamoParser<UserType>,
): Promise<UserType | ResourceNotFoundError> {
  return await dynamo.parsedQuery({
    pk: userPk(id),
    sk: { q: kUserSkPrefix, op: "BEGINS_WITH" },
    limit: 1,
    parseShape: parser,
  });
}

export async function getUser(
  dynamo: DynamoClient,
  id: string,
): Promise<User | ResourceNotFoundError> {
  return await getUserHelper(dynamo, id, kUserParser);
}

export async function getUserExplore(dynamo: DynamoClient, id: string) {
  return await getUserHelper(dynamo, id, kUserExploreParser);
}

export async function getUserWithoutIdentity(
  dynamo: DynamoClient,
  id: string,
): Promise<UserWithoutIdentity | ResourceNotFoundError> {
  return await dynamo.parsedQuery({
    pk: userPk(id),
    sk: { q: newUserSk(id), op: "EQ" },
    parseShape: kUserWithoutIdentityParser,
  });
}

export async function getExploreUsers(
  dynamo: DynamoClient,
  gymId: string,
): Promise<UserExplore[]> {
  return await dynamo.parsedQuery({
    pk: userSk(gymId),
    sk: { q: kUserPkPrefix, op: "BEGINS_WITH" },
    table: "inverted",
    parseShape: kUserExploreParser,
  });
}

const kInitialNumInvites = 5;

export async function createNewUser(
  dynamo: DynamoClient,
  params: {
    id: string;
    firstName: string;
    lastName: string;
    email: string;
    invite: Invite;
  },
) {
  await dynamo.put({
    ...newUserKey(params.id),
    data: userWithoutIdentityToDynamo({
      ...params,
      createdAt: new Date(),
      numInvites: kInitialNumInvites,
    }),
  });
}

export async function deleteUser(
  dynamo: DynamoClient,
  params: {
    id: string;
    gymId: string;
  },
) {
  await Promise.all([
    dynamo.delete(newUserKey(params.id)),
    dynamo.delete(userKey(params.id, params.gymId)),
  ]);
}
