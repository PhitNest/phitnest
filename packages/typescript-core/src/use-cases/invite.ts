import { inviteToDynamo } from "../entities";
import {
  getGym,
  getReceivedInvites,
  getUser,
  inviteKey,
  userKey,
} from "../repositories";
import {
  DynamoClient,
  RequestError,
  ResourceNotFoundError,
} from "../utils";

export async function adminInvite(
  dynamo: DynamoClient,
  params: {
    senderId: string;
    receiverEmail: string;
    gymId: string;
  },
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
  await dynamo.put({
    ...inviteKey("admin", params.senderId, params.receiverEmail),
    data: inviteToDynamo({
      ...params,
      senderType: "admin",
      createdAt: new Date(),
    }),
  });
}

export async function userInvite(
  dynamo: DynamoClient,
  params: {
    senderId: string;
    receiverEmail: string;
  },
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
        {
          ...userKey(params.senderId, sender.invite.gymId),
          expression: "SET numInvites = numInvites - 1",
          varMap: {},
        },
      ],
      puts: [
        {
          ...inviteKey("user", params.senderId, params.receiverEmail),
          data: inviteToDynamo({
            ...params,
            gymId: sender.invite.gymId,
            senderType: "user",
            createdAt: new Date(),
          }),
        },
      ],
    });
  } else {
    return new RequestError("NoInvites", "No invites available");
  }
}
