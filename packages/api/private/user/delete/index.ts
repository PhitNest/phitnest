import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  deleteFriendship,
  deleteInvite,
  deleteUser,
  getFriendships,
  getSentInvites,
} from "typescript-core/src/repositories";
import {
  dynamo,
  Success,
  handleRequest,
  getUserClaims,
  RequestError,
} from "typescript-core/src/utils";

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const [friendships, invites] = await Promise.all([
      getFriendships(client, userClaims.sub),
      getSentInvites(client, userClaims.sub, "user"),
    ]);
    if (friendships instanceof RequestError) {
      return friendships;
    } else {
      await Promise.all([
        deleteUser(client, { id: userClaims.sub, gymId: userClaims.gymId }),
        ...friendships.map((friendship) =>
          deleteFriendship(
            client,
            friendship.sender.id,
            friendship.receiver.id,
          ),
        ),
        ...invites.map((invite) =>
          deleteInvite(client, invite.senderId, invite.receiverEmail, "user"),
        ),
      ]);
    }
    return new Success();
  });
}
