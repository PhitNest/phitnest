import {
  deleteFriendship,
  deleteInvite,
  deleteUser,
  getFriendships,
  getSentInvites,
  getUserWithoutIdentity,
} from "../repositories";
import { DynamoClient, RequestError, ResourceNotFoundError } from "../utils";

export async function deleteUserAccount(
  dynamo: DynamoClient,
  id: string,
): Promise<void | ResourceNotFoundError> {
  const [user, friendships, invites] = await Promise.all([
    getUserWithoutIdentity(dynamo, id),
    getFriendships(dynamo, id),
    getSentInvites(dynamo, id, "user"),
  ]);
  if (user instanceof ResourceNotFoundError) {
    return user;
  } else if (friendships instanceof RequestError) {
    return friendships;
  } else {
    await Promise.all([
      deleteUser(dynamo, { id: id, gymId: user.invite.gymId }),
      ...friendships.map((friendship) =>
        deleteFriendship(dynamo, friendship.sender.id, friendship.receiver.id),
      ),
      ...invites.map((invite) =>
        deleteInvite(dynamo, invite.senderId, invite.receiverEmail, "user"),
      ),
    ]);
  }
}
