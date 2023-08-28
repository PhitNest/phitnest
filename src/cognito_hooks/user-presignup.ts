import { PreSignUpTriggerEvent } from "aws-lambda";
import { createUser } from "common/use_cases";
import { dynamo } from "common/utils";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo();
  const { firstName, lastName } = event.request.validationData ?? {};
  if (!firstName) {
    throw new Error("Missing firstName");
  }
  if (!lastName) {
    throw new Error("Missing lastName");
  }
  await createUser(client, {
    id: event.userName,
    email: event.request.userAttributes.email,
    firstName: firstName,
    lastName: lastName,
  });
  return event;
}
