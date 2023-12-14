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
  handleRequest,
  getUserClaims,
  isResourceNotFound,
  success,
} from "typescript-core/src/utils";

export async function invoke(
  event: APIGatewayEvent
): Promise<APIGatewayProxyResult> {
  return handleRequest(async () => {
    const userClaims = getUserClaims(event);
    const client = dynamo();
    const [friendships, invites, user] = await Promise.all([
      getFriendships(client, userClaims.sub),
      getSentInvites(client, userClaims.sub, "user"),
      getUser(client, userClaims.sub),
    ]);
    if (isResourceNotFound(friendships)) {
      return friendships;
    } else if (isResourceNotFound(user)) {
      return user;
    } else {
      await Promise.all([
        deleteUser(client, { id: userClaims.sub, gymId: user.invite.gymId }),
        ...friendships.flatMap((friendship) => [
          deleteFriendship(
            client,
            friendship.sender.id,
            friendship.receiver.id
          ),
          deleteFriendship(
            client,
            friendship.receiver.id,
            friendship.sender.id
          ),
        ]),
        ...invites.map((invite) =>
          deleteInvite(client, invite.senderId, invite.receiverEmail, "user")
        ),
      ]);
    }
    return success();
  });
}
