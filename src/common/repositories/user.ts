import {
  Invite,
  User,
  UserExplore,
  UserWithoutIdentity,
  kUserExploreParser,
  kUserParser,
  kUserWithoutIdentityParser,
  userToDynamo,
  userWithoutIdentityToDynamo,
} from "common/entities";
import { DynamoParser } from "common/entities/dynamo";
import {
  DynamoClient,
  PutParams,
  ResourceNotFoundError,
  RowKey,
  UpdateParams,
} from "common/utils";

const kUserPkPrefix = "USER#";
const kNewUserSkPrefix = "NEW#";
const kUserSkPrefix = "GYM#";

export function newUserKey(id: string): RowKey {
  return {
    pk: `${kUserPkPrefix}${id}`,
    sk: `${kNewUserSkPrefix}${id}`,
  };
}

function userKey(id: string, gymId: string): RowKey {
  return {
    pk: `${kUserPkPrefix}${id}`,
    sk: `${kUserSkPrefix}${gymId}`,
  };
}

async function getUserHelper<UserType extends UserExplore>(
  dynamo: DynamoClient,
  id: string,
  parser: DynamoParser<UserType>
): Promise<UserType | ResourceNotFoundError> {
  return await dynamo.parsedQuery({
    pk: `${kUserPkPrefix}${id}`,
    sk: { q: kUserSkPrefix, op: "BEGINS_WITH" },
    limit: 1,
    parseShape: parser,
  });
}

export async function getUser(
  dynamo: DynamoClient,
  id: string
): Promise<User | ResourceNotFoundError> {
  return await getUserHelper(dynamo, id, kUserParser);
}

export async function getUserWithoutIdentity(
  dynamo: DynamoClient,
  id: string
): Promise<UserWithoutIdentity | ResourceNotFoundError> {
  return await dynamo.parsedQuery({
    pk: `${kUserPkPrefix}${id}`,
    sk: { q: `${kNewUserSkPrefix}${id}`, op: "EQ" },
    parseShape: kUserWithoutIdentityParser,
  });
}

export async function getUserExplore(dynamo: DynamoClient, id: string) {
  return await getUserHelper(dynamo, id, kUserExploreParser);
}

export async function getExploreUsers(
  dynamo: DynamoClient,
  gymId: string
): Promise<UserExplore[]> {
  return await dynamo.parsedQuery({
    pk: `${kUserSkPrefix}${gymId}`,
    sk: { q: kUserPkPrefix, op: "BEGINS_WITH" },
    table: "inverted",
    parseShape: kUserExploreParser,
  });
}

export function createUserExploreParams(user: User): PutParams {
  return {
    ...userKey(user.id, user.invite.gymId),
    data: userToDynamo(user),
  };
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
  }
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

export function createDecrementNumInvitesParameters(
  id: string,
  gymId: string
): UpdateParams {
  return {
    ...userKey(id, gymId),
    expression: "SET numInvites = numInvites - 1",
    varMap: {},
  };
}

export function deleteUser(
  dynamo: DynamoClient,
  params: {
    id: string;
    gymId: string;
  }
): [Promise<void>, Promise<void>] {
  return [
    dynamo.delete(newUserKey(params.id)),
    dynamo.delete(userKey(params.id, params.gymId)),
  ];
}
