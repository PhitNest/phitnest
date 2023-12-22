import { PreSignUpTriggerEvent } from "aws-lambda";
import { userWithoutIdentityToDynamo } from "typescript-core/src/entities";
import { newUserKey } from "typescript-core/src/repositories";
import { dynamo } from "typescript-core/src/utils";

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
  await client.put({
    ...newUserKey(event.userName),
    data: userWithoutIdentityToDynamo(newUserWithoutInvite),
  });
  return event;
}
