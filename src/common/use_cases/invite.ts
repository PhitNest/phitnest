import {
  createDecrementNumInvitesParameters,
  createInviteParameters,
  getGym,
  getReceivedInvites,
  getUser,
} from "common/repositories";
import {
  DynamoClient,
  RequestError,
  ResourceNotFoundError,
} from "common/utils";

export async function adminInvite(
  dynamo: DynamoClient,
  params: {
    senderId: string;
    receiverEmail: string;
    gymId: string;
  }
): Promise<void | RequestError> {
  const [gym, existingInvite] = await Promise.all([
    getGym(dynamo, params.gymId),
    getReceivedInvites(dynamo, params.receiverEmail, 1),
  ]);
  if (!(existingInvite instanceof ResourceNotFoundError)) {
    return new RequestError("InviteAlreadyExists", "Invite already exists");
  }
  if (gym instanceof ResourceNotFoundError) {
    return gym;
  }
  await dynamo.put(createInviteParameters({ ...params, senderType: "admin" }));
}

export async function userInvite(
  dynamo: DynamoClient,
  params: {
    senderId: string;
    receiverEmail: string;
  }
): Promise<void | RequestError> {
  const [sender, existingInvite] = await Promise.all([
    getUser(dynamo, params.senderId),
    getReceivedInvites(dynamo, params.receiverEmail, 1),
  ]);
  if (!(existingInvite instanceof ResourceNotFoundError)) {
    return new RequestError("InviteAlreadyExists", "Invite already exists");
  }
  if (sender instanceof ResourceNotFoundError) {
    return sender;
  }
  if (sender.numInvites > 0) {
    await dynamo.writeTransaction({
      updates: [
        createDecrementNumInvitesParameters(
          params.senderId,
          sender.invite.gymId
        ),
      ],
      puts: [
        createInviteParameters({
          ...params,
          gymId: sender.invite.gymId,
          senderType: "user",
        }),
      ],
    });
  } else {
    return new RequestError("NoInvites", "No invites available");
  }
}
