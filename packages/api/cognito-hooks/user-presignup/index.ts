import { PreSignUpTriggerEvent } from "aws-lambda";
import {
  createNewUser,
  getReceivedInvites,
} from "typescript-core/src/repositories";
import {
  RequestError,
  ResourceNotFoundError,
  dynamo,
} from "typescript-core/src/utils";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo();
  const { firstName, lastName } = event.request.validationData ?? {};
  if (!firstName) {
    throw new Error("Missing firstName");
  }
  if (!lastName) {
    throw new Error("Missing lastName");
  }
  const newUserWithoutInvite = {
    id: event.userName,
    firstName: firstName,
    lastName: lastName,
    email: event.request.userAttributes.email,
    createdAt: new Date(),
  };
  const invite = await getReceivedInvites(
    client,
    newUserWithoutInvite.email,
    1,
  );
  if (invite instanceof ResourceNotFoundError) {
    return new RequestError("InviteNotFound", "Invite not found");
  }
  await createNewUser(client, { ...newUserWithoutInvite, invite: invite });
  return event;
}
