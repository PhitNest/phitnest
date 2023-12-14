import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  dynamo,
  getUserClaims,
  handleRequest,
  RequestError,
  DynamoClient,
  EnvironmentVars,
  TransactionParams,
  ResourceNotFound,
  isResourceNotFound,
  requestError,
  isRequestError,
  success,
} from "typescript-core/src/utils";
import {
  friendshipKey,
  getExploreUsers,
  getFriendships,
  getGym,
  getUser,
  getUserExplore,
  getUserWithoutIdentity,
  newUserKey,
  userKey,
} from "typescript-core/src/repositories";
import {
  User,
  FriendWithoutMessageToDynamo,
  userToDynamo,
} from "typescript-core/src/entities";
import { fromCognitoIdentityPool } from "@aws-sdk/credential-provider-cognito-identity";
import { CognitoIdentityClient } from "@aws-sdk/client-cognito-identity";
import * as uuid from "uuid";

async function createIdentity(
  dynamo: DynamoClient,
  userId: string,
  authorization: string | undefined
): Promise<
  | User
  | ResourceNotFound
  | RequestError<"Unauthorized">
  | RequestError<"IdentityAuthenticationFailed">
> {
  const newUser = await getUserWithoutIdentity(dynamo, userId);
  if (isResourceNotFound(newUser)) {
    return newUser;
  }
  if (!authorization) {
    return requestError(
      "Unauthorized",
      "No Authorization header found on request."
    );
  }
  const identityClient = new CognitoIdentityClient({
    region: EnvironmentVars.region(),
    credentials: fromCognitoIdentityPool({
      client: new CognitoIdentityClient({
        region: EnvironmentVars.region(),
      }),
      identityPoolId: EnvironmentVars.userIdentityPoolId(),
      logins: {
        [`cognito-idp.${EnvironmentVars.region()}.amazonaws.com/${EnvironmentVars.userPoolId()}`]:
          authorization,
      },
    }),
  });
  const identity = (await identityClient.config.credentials()) as unknown as {
    identityId: string;
  };
  if (!identity || !identity.identityId) {
    return requestError(
      "IdentityAuthenticationFailed",
      "Could not authenticate with identity pool."
    );
  }
  const userWithIdentity: User = {
    ...newUser,
    identityId: identity.identityId,
  };
  const transaction: TransactionParams = {
    deletes: [newUserKey(userWithIdentity.id)],
    puts: [
      {
        ...userKey(userWithIdentity.id, userWithIdentity.invite.gymId),
        data: userToDynamo(userWithIdentity),
      },
    ],
  };
  if (userWithIdentity.invite.senderType === "user") {
    const sender = await getUserExplore(
      dynamo,
      userWithIdentity.invite.senderId
    );
    if (isResourceNotFound(sender)) {
      return sender;
    }
    transaction.puts?.push({
      ...friendshipKey(sender.id, userWithIdentity.id),
      data: FriendWithoutMessageToDynamo({
        id: uuid.v4(),
        createdAt: new Date(),
        acceptedAt: new Date(),
        receiver: {
          id: userWithIdentity.id,
          firstName: userWithIdentity.firstName,
          lastName: userWithIdentity.lastName,
          identityId: userWithIdentity.identityId,
          createdAt: userWithIdentity.createdAt,
        },
        sender: sender,
        __poly__: "FriendWithoutMessage",
      }),
    });
  }
  await dynamo.writeTransaction(transaction);
  return userWithIdentity;
}

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    let user:
      | User
      | ResourceNotFound
      | RequestError<"Unauthorized">
      | RequestError<"IdentityAuthenticationFailed"> = await getUser(
      client,
      userClaims.sub
    );
    if (isRequestError(user)) {
      user = await createIdentity(
        client,
        userClaims.sub,
        event.headers.Authorization
      );
      if (isRequestError(user)) {
        return user;
      }
    }
    if (isRequestError(user)) {
      return user;
    }
    const [gym, exploreUsers, friendships] = await Promise.all([
      getGym(client, user.invite.gymId),
      getExploreUsers(client, user.invite.gymId),
      getFriendships(client, userClaims.sub),
    ]);
    if (isResourceNotFound(friendships)) {
      return friendships;
    }
    if (isResourceNotFound(gym)) {
      return gym;
    }
    return success({
      user: user,
      exploreUsers: exploreUsers,
      friendships: friendships,
      gym: gym,
    });
  });
}
