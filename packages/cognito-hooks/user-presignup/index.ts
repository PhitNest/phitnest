import { PreSignUpTriggerEvent } from "aws-lambda";
import {
  Invite,
  userWithoutIdentityToDynamo,
} from "typescript-core/src/entities";
import {
  getReceivedInvites,
  newUserKey,
} from "typescript-core/src/repositories";
import {
  ResourceNotFound,
  dynamo,
  requestError,
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
    email: event.request.userAttributes.email.toLowerCase(),
    createdAt: new Date(),
  };
  const client = dynamo();
  const invite = await getReceivedInvites(
    client,
    newUserWithoutInvite.email,
    1
  );
  const resourceNotFound = invite as ResourceNotFound;
  if (resourceNotFound.type === "ResourceNotFoundError") {
    return requestError("InviteNotFound", "Invite not found");
  }
  const foundInvite = invite as Invite;
  await client.put({
    ...newUserKey(event.userName),
    data: userWithoutIdentityToDynamo({
      ...newUserWithoutInvite,
      invite: foundInvite,
      createdAt: new Date(),
      numInvites: kInitialNumInvites,
    }),
  });
  return event;
}
