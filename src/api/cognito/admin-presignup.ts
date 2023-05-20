import { TransactWriteItemsCommand } from "@aws-sdk/client-dynamodb";
import { connectDynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = connectDynamo();
  const { firstName, lastName } = event.request.userAttributes;
  if (firstName && lastName) {
    await client.send(
      new TransactWriteItemsCommand({
        TransactItems: [
          {
            Put: {
              TableName: process.env.DYNAMO_TABLE_NAME,
              Item: {
                part_id: { S: "ADMINS" },
                sort_id: { S: `ADMIN#${event.userName}` },
                firstName: { S: event.request.userAttributes.firstName },
                lastName: { S: event.request.userAttributes.lastName },
                email: { S: event.request.userAttributes.email },
              },
            },
          },
        ],
      })
    );
  } else {
    throw new Error("Missing required attributes");
  }
}
