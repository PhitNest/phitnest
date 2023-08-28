import {
  deleteFriendRequest,
  deleteFriendship,
  deleteInvite,
  deleteUser,
  getFriendships,
  getReceivedFriendRequests,
  getSentFriendRequests,
  getSentInvites,
  getUserWithoutIdentity,
} from "common/repository";
import { DynamoClient, ResourceNotFoundError } from "common/utils";

export async function deleteUserAccount(
  dynamo: DynamoClient,
  id: string
): Promise<void | ResourceNotFoundError> {
  const [user, receivedRequests, sentRequests, friendships, invites] =
    await Promise.all([
      getUserWithoutIdentity(dynamo, id),
      getReceivedFriendRequests(dynamo, id),
      getSentFriendRequests(dynamo, id),
      getFriendships(dynamo, id),
      getSentInvites(dynamo, id, "user"),
    ]);
  if (user instanceof ResourceNotFoundError) {
    return user;
  } else {
    await Promise.all([
      deleteUser(dynamo, { id: id, gymId: user.invite.gymId }),
      ...receivedRequests.map((request) =>
        deleteFriendRequest(dynamo, request.sender.id, request.receiver.id)
      ),
      ...sentRequests.map((request) =>
        deleteFriendRequest(dynamo, request.sender.id, request.receiver.id)
      ),
      ...friendships.map((friendship) =>
        deleteFriendship(dynamo, friendship.sender.id, friendship.receiver.id)
      ),
      ...invites.map((invite) =>
        deleteInvite(dynamo, invite.senderId, invite.receiverEmail, "user")
      ),
    ]);
  }
}
