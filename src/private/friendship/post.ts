import {
  dynamo,
  validateRequest,
  getUserClaims,
  RequestError,
  Success,
  CognitoClaimsError,
  ResourceNotFoundError,
} from "common/utils";
import {
  kFriendshipParser,
  FriendshipWithoutMessage,
  friendshipWithoutMessageToDynamo,
  kIncomingFriendRequestParser,
  kUserExploreParser,
  kOutgoingFriendRequestParser,
  OutgoingFriendRequest,
  IncomingFriendRequest,
  outgoingFriendRequestToDynamo,
  incomingFriendRequestToDynamo,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import * as uuid from "uuid";
import { z } from "zod";

const validator = z.object({
  receiverId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const userClaims = getUserClaims(event);
      if (userClaims instanceof CognitoClaimsError) {
        return userClaims;
      } else {
        const client = dynamo().connect();
        const [friendRequest, outgoingRequest, friendship, sender, receiver] =
          await Promise.all([
            client.parsedQuery({
              pk: `INCOMING_REQUEST#${userClaims.sub}`,
              sk: { q: `SENDER#${data.receiverId}`, op: "EQ" },
              parseShape: kIncomingFriendRequestParser,
            }),
            client.parsedQuery({
              pk: `USER#${userClaims.sub}`,
              sk: { q: `FRIEND_REQUEST#${data.receiverId}`, op: "EQ" },
              parseShape: kOutgoingFriendRequestParser,
            }),
            client.parsedQuery({
              pk: `USER#${userClaims.sub}`,
              sk: { q: `FRIENDSHIP#${data.receiverId}`, op: "EQ" },
              parseShape: kFriendshipParser,
            }),
            client.parsedQuery({
              pk: "USERS",
              sk: { q: `USER#${userClaims.sub}`, op: "EQ" },
              parseShape: kUserExploreParser,
            }),
            client.parsedQuery({
              pk: "USERS",
              sk: { q: `USER#${data.receiverId}`, op: "EQ" },
              parseShape: kUserExploreParser,
            }),
          ]);
        if (receiver instanceof RequestError) {
          return receiver;
        } else if (sender instanceof RequestError) {
          return sender;
        } else if (friendship instanceof ResourceNotFoundError) {
          if (outgoingRequest instanceof ResourceNotFoundError) {
            if (friendRequest instanceof ResourceNotFoundError) {
              const senderRequest: OutgoingFriendRequest = {
                receiver: receiver,
                createdAt: new Date(),
                id: uuid.v4(),
              };
              const receiverRequest: IncomingFriendRequest = {
                sender: sender,
                createdAt: new Date(),
                id: uuid.v4(),
              };
              await client.writeTransaction({
                puts: [
                  {
                    pk: `USER#${userClaims.sub}`,
                    sk: `FRIEND_REQUEST#${data.receiverId}`,
                    data: outgoingFriendRequestToDynamo(senderRequest),
                  },
                  {
                    pk: `INCOMING_REQUEST#${data.receiverId}`,
                    sk: `SENDER#${userClaims.sub}`,
                    data: incomingFriendRequestToDynamo(receiverRequest),
                  },
                ],
                updates: [],
                deletes: [],
              });
              return new Success(senderRequest);
            } else {
              const friendshipCreatedAt = new Date();
              const friendshipId = uuid.v4();
              const senderFriendship: FriendshipWithoutMessage = {
                otherUser: receiver,
                createdAt: friendshipCreatedAt,
                id: friendshipId,
              };
              const receiverFriendship: FriendshipWithoutMessage = {
                otherUser: sender,
                createdAt: friendshipCreatedAt,
                id: friendshipId,
              };
              await client.writeTransaction({
                updates: [],
                deletes: [
                  {
                    pk: `USER#${data.receiverId}`,
                    sk: `FRIEND_REQUEST#${userClaims.sub}`,
                  },
                  {
                    pk: `INCOMING_REQUEST#${userClaims.sub}`,
                    sk: `SENDER#${data.receiverId}`,
                  },
                ],
                puts: [
                  {
                    pk: `USER#${userClaims.sub}`,
                    sk: `FRIENDSHIP#${data.receiverId}`,
                    data: friendshipWithoutMessageToDynamo(senderFriendship),
                  },
                  {
                    pk: `USER#${data.receiverId}`,
                    sk: `FRIENDSHIP#${userClaims.sub}`,
                    data: friendshipWithoutMessageToDynamo(receiverFriendship),
                  },
                ],
              });
              return new Success(senderFriendship);
            }
          } else {
            return new RequestError(
              "FriendRequestAlreadyExists",
              "You have already sent a friend request to this user."
            );
          }
        } else {
          return new RequestError(
            "FriendshipAlreadyExists",
            "You are already friends with this user."
          );
        }
      }
    },
  });
}
