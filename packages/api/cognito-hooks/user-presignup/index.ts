import { PreSignUpTriggerEvent } from "aws-lambda";
import { userWithoutIdentityToDynamo } from "typescript-core/src/entities";
import {
  getReceivedInvites,
  newUserKey,
} from "typescript-core/src/repositories";
import {
  RequestError,
  ResourceNotFoundError,
  dynamo,
} from "typescript-core/src/utils";

const kInitialNumInvites = 5;

export async function invoke(event: PreSignUpTriggerEvent) {
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
  const client = dynamo();
  const invite = await getReceivedInvites(
    client,
    newUserWithoutInvite.email,
    1,
  );
  if (invite instanceof ResourceNotFoundError) {
    return new RequestError("InviteNotFound", "Invite not found");
  }
  await client.put({
    ...newUserKey(event.userName),
    data: userWithoutIdentityToDynamo({
      ...newUserWithoutInvite,
      invite: invite,
      createdAt: new Date(),
      numInvites: kInitialNumInvites,
    }),
  });
  return event;
}
