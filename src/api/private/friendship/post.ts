import {
  dynamo,
  validateRequest,
  getUserClaims,
  RequestError,
  Success,
} from "api/common/utils";
import {
  kFriendshipDynamo,
  kFriendRequestDynamo,
  friendRequestToDynamo,
  kUserExploreDynamo,
  FriendRequest,
  FriendshipWithoutMessage,
  friendshipWithoutMessageToDynamo,
} from "api/common/entities";
import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import * as uuid from "uuid";
import { z } from "zod";

const validator = z.object({
  userId: z.string(),
  receiverId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: {
      userId: getUserClaims(event)?.sub,
      ...JSON.parse(event.body ?? "{}"),
    },
    validator: validator,
    controller: async (data) => {
      const client = dynamo().connect();
      const [friendRequest, friendship, sender, receiver] = await Promise.all([
        client
          .parsedQuery({
            pk: `USER#${data.receiverId}`,
            sk: { q: `FRIEND_REQUEST#${data.userId}`, op: "EQ" },
            parseShape: kFriendRequestDynamo,
          })
          .catch(() => null),
        client
          .parsedQuery({
            pk: `USER#${data.receiverId}`,
            sk: { q: `FRIENDSHIP#${data.userId}`, op: "EQ" },
            parseShape: kFriendshipDynamo,
          })
          .catch(() => null),
        client.parsedQuery({
          pk: "USERS",
          sk: { q: `USER#${data.userId}`, op: "EQ" },
          parseShape: kUserExploreDynamo,
        }),
        client.parsedQuery({
          pk: "USERS",
          sk: { q: `USER#${data.receiverId}`, op: "EQ" },
          parseShape: kUserExploreDynamo,
        }),
      ]);
      if (friendship) {
        return new RequestError(
          "FriendshipAlreadyExists",
          "You are already friends with this user."
        );
      }
      if (friendRequest) {
        const newFriendship: FriendshipWithoutMessage = {
          users: [sender, receiver],
          createdAt: new Date(),
          id: uuid.v4(),
        };
        await client.writeTransaction({
          updates: [],
          deletes: [
            {
              pk: `USER#${data.receiverId}`,
              sk: `FRIEND_REQUEST#${data.userId}`,
            },
            {
              pk: `INCOMING_REQUEST#${data.userId}`,
              sk: `SENDER#${data.receiverId}`,
            },
          ],
          puts: [
            {
              pk: `USER#${data.userId}`,
              sk: `FRIENDSHIP#${data.receiverId}`,
              data: friendshipWithoutMessageToDynamo(newFriendship),
            },
            {
              pk: `USER#${data.receiverId}`,
              sk: `FRIENDSHIP#${data.userId}`,
              data: friendshipWithoutMessageToDynamo(newFriendship),
            },
          ],
        });
        return new Success(newFriendship);
      } else {
        const newRequest: FriendRequest = {
          users: [sender, receiver],
          createdAt: new Date(),
          id: uuid.v4(),
        };
        await client.writeTransaction({
          puts: [
            {
              pk: `USER#${data.userId}`,
              sk: `FRIEND_REQUEST#${data.receiverId}`,
              data: friendRequestToDynamo(newRequest),
            },
            {
              pk: `INCOMING_REQUEST#${data.userId}`,
              sk: `SENDER#${data.receiverId}`,
              data: friendRequestToDynamo(newRequest),
            },
          ],
          updates: [],
          deletes: [],
        });
        return new Success(newRequest);
      }
    },
  });
}
