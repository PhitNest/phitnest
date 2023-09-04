import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  deleteFriendship,
  deleteInvite,
  deleteUser,
  getFriendships,
  getSentInvites,
  getUser,
} from "typescript-core/src/repositories";
import {
  dynamo,
  Success,
  handleRequest,
  getUserClaims,
  RequestError,
  ResourceNotFoundError,
} from "typescript-core/src/utils";

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const [friendships, invites, user] = await Promise.all([
      getFriendships(client, userClaims.sub),
      getSentInvites(client, userClaims.sub, "user"),
      getUser(client, userClaims.sub),
    ]);
    if (friendships instanceof RequestError) {
      return friendships;
    } else if (user instanceof ResourceNotFoundError) {
      return user;
    } else {
      await Promise.all([
        deleteUser(client, { id: userClaims.sub, gymId: user.invite.gymId }),
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
