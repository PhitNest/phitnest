import { createNewUser, getReceivedInvites } from "common/repository";
import {
  DynamoClient,
  RequestError,
  ResourceNotFoundError,
} from "common/utils";

export async function createUser(
  dynamo: DynamoClient,
  params: {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
  }
): Promise<void | RequestError> {
  const newUserWithoutInvite = {
    ...params,
    createdAt: new Date(),
  };
  const invite = await getReceivedInvites(
    dynamo,
    newUserWithoutInvite.email,
    1
  );
  if (invite instanceof ResourceNotFoundError) {
    return new RequestError("InviteNotFound", "Invite not found");
  }
  await createNewUser(dynamo, { ...newUserWithoutInvite, invite: invite });
}
