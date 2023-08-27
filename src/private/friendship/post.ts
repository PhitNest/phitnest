import {
  dynamo,
  validateRequest,
  getUserClaims,
  RequestError,
  Success,
  ResourceNotFoundError,
} from "common/utils";
import {
  kFriendshipParser,
  FriendshipWithoutMessage,
  friendshipWithoutMessageToDynamo,
  kUserExploreParser,
  kFriendRequestParser,
  FriendRequest,
  friendRequestToDynamo,
} from "common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import * as uuid from "uuid";

const validator = z.object({
  receiverId: z.string(),
});

const kFriendRequestExists = new RequestError(
  "FriendRequestExists",
  "Outgoing friend request already exists"
);

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
      const client = dynamo();
      const [
        receivedRequest,
        sentRequest,
        sentFriendship,
        receivedFriendship,
        sender,
        receiver,
      ] = await Promise.all([
        client.parsedQuery({
          pk: `USER#${data.receiverId}`,
          sk: { q: `FRIEND_REQUEST#${userClaims.sub}`, op: "EQ" },
          parseShape: kFriendRequestParser,
        }),
        client.parsedQuery({
          pk: `USER#${userClaims.sub}`,
          sk: { q: `FRIEND_REQUEST#${data.receiverId}`, op: "EQ" },
          parseShape: kFriendRequestParser,
        }),
        client.parsedQuery({
          pk: `USER#${userClaims.sub}`,
          sk: { q: `FRIENDSHIP#${data.receiverId}`, op: "EQ" },
          parseShape: kFriendshipParser,
        }),
        client.parsedQuery({
          pk: `USER#${data.receiverId}`,
          sk: { q: `FRIENDSHIP#${userClaims.sub}`, op: "EQ" },
          parseShape: kFriendshipParser,
        }),
        client.parsedQuery({
          pk: `USER#${userClaims.sub}`,
          sk: { q: "GYM#", op: "BEGINS_WITH" },
          limit: 1,
          parseShape: kUserExploreParser,
        }),
        client.parsedQuery({
          pk: `USER#${data.receiverId}`,
          sk: { q: "GYM#", op: "BEGINS_WITH" },
          limit: 1,
          parseShape: kUserExploreParser,
        }),
      ]);
      if (receiver instanceof ResourceNotFoundError) {
        return receiver;
      } else if (sender instanceof ResourceNotFoundError) {
        return sender;
      } else if (
        sentFriendship instanceof ResourceNotFoundError &&
        receivedFriendship instanceof ResourceNotFoundError
      ) {
        if (sentRequest instanceof ResourceNotFoundError) {
          if (receivedRequest instanceof ResourceNotFoundError) {
            const request: FriendRequest = {
              receiver: receiver,
              sender: sender,
              createdAt: new Date(),
              id: uuid.v4(),
            };
            await client.put({
              pk: `USER#${userClaims.sub}`,
              sk: `FRIEND_REQUEST#${data.receiverId}`,
              data: friendRequestToDynamo(request),
            });
            return new Success(request);
          } else {
            const friendshipCreatedAt = new Date();
            const friendshipId = uuid.v4();
            const friendship: FriendshipWithoutMessage = {
              receiver: sender,
              sender: receiver,
              createdAt: friendshipCreatedAt,
              id: friendshipId,
            };
            await client.writeTransaction({
              deletes: [
                {
                  pk: `USER#${data.receiverId}`,
                  sk: `FRIEND_REQUEST#${userClaims.sub}`,
                },
              ],
              puts: [
                {
                  pk: `USER#${data.receiverId}`,
                  sk: `FRIENDSHIP#${userClaims.sub}`,
                  data: friendshipWithoutMessageToDynamo(friendship),
                },
              ],
            });
            return new Success(friendship);
          }
        } else {
          return kFriendRequestExists;
        }
      } else {
        return kFriendshipExists;
      }
    },
  });
}
