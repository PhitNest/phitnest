import { TransactWriteItemsCommand } from "@aws-sdk/client-dynamodb";
import { Admin, adminToDynamo } from "api/common/entities";
import { connectDynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = connectDynamo();
  const admin: Admin = {
    accountDetails: {
      email: event.request.userAttributes.email,
      id: event.userName,
      createdAt: new Date(),
    },
  };
  await client.send(
    new TransactWriteItemsCommand({
      TransactItems: [
        {
          Put: {
            TableName: process.env.DYNAMO_TABLE_NAME,
            Item: {
              part_id: { S: "ADMINS" },
              sort_id: { S: `ADMIN#${event.userName}` },
              ...adminToDynamo(admin),
            },
          },
        },
      ],
    })
  );
  return event;
}
