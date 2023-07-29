import {
  dynamo,
  validateRequest,
  getUserClaims,
  RequestError,
  Success,
  ResourceNotFoundError,
  kUserNotFound,
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
import { z } from "zod";
import * as uuid from "uuid";

const validator = z.object({
  receiverId: z.string(),
});

const kReceiverNotFound = new RequestError(
  "ReceiverNotFound",
  "Could not find receiver"
);

class FriendRequestExists extends RequestError {
  constructor(outgoing: boolean) {
    super(
      "FriendRequestExists",
      `${outgoing ? "Outgoing" : "Incoming"} friend request already exists`
    );
  }
}

const kFriendshipExists = new RequestError(
  "FriendshipExists",
  "Friendship already exists"
);

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const userClaims = getUserClaims(event);
      const client = dynamo().connect();
      const [friendRequest, outgoingRequest, friendship, sender, receiver] =
        await Promise.all([
          client.parsedQuery({
            pk: `USER#${userClaims.sub}`,
            sk: { q: `INCOMING_REQUEST#${data.receiverId}`, op: "EQ" },
            parseShape: kIncomingFriendRequestParser,
          }),
          client.parsedQuery({
            pk: `USER#${userClaims.sub}`,
            sk: { q: `OUTGOING_REQUEST#${data.receiverId}`, op: "EQ" },
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
      if (receiver instanceof ResourceNotFoundError) {
        return kReceiverNotFound;
      } else if (sender instanceof ResourceNotFoundError) {
        return kUserNotFound;
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
                  sk: `OUTGOING_REQUEST#${data.receiverId}`,
                  data: outgoingFriendRequestToDynamo(senderRequest),
                },
                {
                  pk: `USER#${data.receiverId}`,
                  sk: `INCOMING_REQUEST#${userClaims.sub}`,
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
                  sk: `OUGOING_REQUEST#${userClaims.sub}`,
                },
                {
                  pk: `USER#${userClaims.sub}`,
                  sk: `INCOMING_REQUEST#${data.receiverId}`,
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
          return new FriendRequestExists(true);
        }
      } else {
        return kFriendshipExists;
      }
    },
  });
}
