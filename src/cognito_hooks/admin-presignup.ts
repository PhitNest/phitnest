import { PreSignUpTriggerEvent } from "aws-lambda";
import { createAdmin } from "common/repository";
import { dynamo } from "common/utils";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo();
  await createAdmin(client, event.userName, event.request.userAttributes.email);
  return event;
}
