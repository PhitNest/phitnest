import { adminToDynamo } from "common/entities";
import { dynamo } from "common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo();
  await client.put({
    pk: "ADMINS",
    sk: `ADMIN#${event.userName}`,
    data: adminToDynamo({
      email: event.request.userAttributes.email,
      id: event.userName,
      createdAt: new Date(),
    }),
  });
  return event;
}
