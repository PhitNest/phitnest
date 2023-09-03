import { CognitoIdentityClient } from "@aws-sdk/client-cognito-identity";
import { fromCognitoIdentityPool } from "@aws-sdk/credential-provider-cognito-identity";
import * as uuid from "uuid";
import {
  User,
  friendshipWithoutMessageToDynamo,
  userToDynamo,
} from "../entities";
import {
  friendshipKey,
  getUserExplore,
  getUserWithoutIdentity,
  newUserKey,
  userKey,
} from "../repositories";
import {
  DynamoClient,
  EnvironmentVars,
  RequestError,
  ResourceNotFoundError,
  TransactionParams,
} from "../utils";

export async function createIdentity(
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
