import { TransactWriteItemsCommand } from "@aws-sdk/client-dynamodb";
import { connectDynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = connectDynamo();
  await client.send(
    new TransactWriteItemsCommand({
      TransactItems: [
        {
          Put: {
            TableName: process.env.DYNAMO_TABLE_NAME,
            Item: {
              part_id: { S: "ADMINS" },
              sort_id: { S: `ADMIN#${event.userName}` },
              email: { S: event.request.userAttributes.email },
            },
          },
        },
      ],
    })
  );
  return event;
}
