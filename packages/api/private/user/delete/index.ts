import { APIGatewayEvent, APIGatewayProxyResult } from "aws-lambda";
import {
  deleteFriendship,
  deleteInvite,
  deleteUser,
  getFriendships,
  getSentInvites,
  getUserWithoutIdentity,
} from "typescript-core/src/repositories";
import {
  dynamo,
  Success,
  handleRequest,
  getUserClaims,
  ResourceNotFoundError,
  RequestError,
} from "typescript-core/src/utils";

export async function invoke(
  event: APIGatewayEvent,
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const [user, friendships, invites] = await Promise.all([
      getUserWithoutIdentity(client, userClaims.sub),
      getFriendships(client, userClaims.sub),
      getSentInvites(client, userClaims.sub, "user"),
    ]);
    if (user instanceof ResourceNotFoundError) {
      return user;
    } else if (friendships instanceof RequestError) {
      return friendships;
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
