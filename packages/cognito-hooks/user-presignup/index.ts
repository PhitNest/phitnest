import { PreSignUpTriggerEvent } from "aws-lambda";
import { userWithoutIdentityToDynamo } from "typescript-core/src/entities";
import {
  getReceivedInvites,
  newUserKey,
} from "typescript-core/src/repositories";
import {
  dynamo,
  isResourceNotFound,
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
  if (isResourceNotFound(invite)) {
    return requestError("InviteNotFound", "Invite not found");
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
