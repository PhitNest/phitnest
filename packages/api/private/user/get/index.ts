import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  dynamo,
  Success,
  getUserClaims,
  handleRequest,
  RequestError,
  DynamoClient,
  ResourceNotFoundError,
  EnvironmentVars,
  TransactionParams,
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
  friendshipWithoutMessageToDynamo,
  userToDynamo,
} from "typescript-core/src/entities";
import { fromCognitoIdentityPool } from "@aws-sdk/credential-provider-cognito-identity";
import { CognitoIdentityClient } from "@aws-sdk/client-cognito-identity";
import * as uuid from "uuid";

async function createIdentity(
  dynamo: DynamoClient,
  userId: string,
  authorization: string | undefined,
): Promise<User | RequestError> {
  const newUser = await getUserWithoutIdentity(dynamo, userId);
  if (newUser instanceof ResourceNotFoundError) {
    return newUser;
  }
  if (!authorization) {
    return new RequestError(
      "Unauthorized",
      "No Authorization header found on request.",
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
    return new RequestError(
      "IdentityAuthenticationFailed",
      "Could not authenticate with identity pool.",
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
      userWithIdentity.invite.senderId,
    );
    if (sender instanceof ResourceNotFoundError) {
      return sender;
    }
    transaction.puts?.push({
      ...friendshipKey(sender.id, userWithIdentity.id),
      data: friendshipWithoutMessageToDynamo({
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
        __poly__: "FriendshipWithoutMessage",
      }),
    });
  }
  await dynamo.writeTransaction(transaction);
  return userWithIdentity;
}

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    let user: User | RequestError = await getUser(client, userClaims.sub);
    if (user instanceof RequestError) {
      user = await createIdentity(
        client,
        userClaims.sub,
        event.headers.Authorization,
      );
      if (user instanceof RequestError) {
        return user;
      }
    }
    if (user instanceof ResourceNotFoundError) {
      return user;
    }
    const [gym, exploreUsers, friendships] = await Promise.all([
      getGym(client, user.invite.gymId),
      getExploreUsers(client, user.invite.gymId),
      getFriendships(client, userClaims.sub),
    ]);
    if (friendships instanceof RequestError) {
      return friendships;
    }
    if (gym instanceof ResourceNotFoundError) {
      return gym;
    }
    return new Success({
      user: user,
      exploreUsers: exploreUsers,
      friendships: friendships,
      gym: gym,
    });
  });
}
