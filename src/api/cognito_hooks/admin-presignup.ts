import { adminToDynamo } from "api/common/entities";
import { dynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = dynamo().connect();
  await client.put({
    pk: "ADMINS",
    sk: `ADMIN#${event.userName}`,
    data: adminToDynamo({
      accountDetails: {
        email: event.request.userAttributes.email,
        id: event.userName,
        createdAt: new Date(),
      },
    }),
  });
  return event;
}
