import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import { z } from "zod";
import {
  dynamo,
  validateRequest,
  getUserClaims,
  RequestError,
  ResourceNotFoundError,
  Success,
} from "typescript-core/src/utils";
import {
  createFriendship,
  friendshipKey,
  getFriendship,
  getUserExplore,
} from "typescript-core/src/repositories";
import {
  FriendRequest,
  friendRequestToDynamo,
} from "typescript-core/src/entities";
import * as uuid from "uuid";

const validator = z.object({
  receiverId: z.string(),
});

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return validateRequest({
    data: JSON.parse(event.body ?? "{}"),
    validator: validator,
    controller: async (data) => {
      const userClaims = getUserClaims(event);
      const client = dynamo();
      const friendship = await getFriendship(
        client,
        userClaims.sub,
        data.receiverId,
      );
      if (friendship instanceof RequestError) {
        const [sender, receiver] = await Promise.all([
          getUserExplore(client, userClaims.sub),
          getUserExplore(client, data.receiverId),
        ]);
        if (sender instanceof ResourceNotFoundError) {
          return sender;
        }
        if (receiver instanceof ResourceNotFoundError) {
          return receiver;
        }
        const friendRequest: FriendRequest = {
          id: uuid.v4(),
          sender: sender,
          receiver: receiver,
          createdAt: new Date(),
          __poly__: "FriendRequest",
        };
        await client.put({
          ...friendshipKey(sender.id, receiver.id),
          data: friendRequestToDynamo(friendRequest),
        });
        return new Success(friendRequest);
      } else {
        switch (friendship.__poly__) {
          case "FriendRequest":
            if (friendship.sender.id === userClaims.sub) {
              return new RequestError(
                "FriendRequestExists",
                "Outgoing friend request already exists",
              );
            } else {
              return new Success(await createFriendship(client, friendship));
            }
          default:
            return new RequestError(
              "FriendshipExists",
              "Friendship already exists",
            );
        }
      }
    },
  });
}
