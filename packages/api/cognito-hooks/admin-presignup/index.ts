import { PreSignUpTriggerEvent } from "aws-lambda";
import { createAdmin } from "typescript-core/src/repositories";
import { dynamo } from "typescript-core/src/utils";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo();
  await createAdmin(client, event.userName, event.request.userAttributes.email);
  return event;
}
