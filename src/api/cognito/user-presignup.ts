import { TransactWriteItemsCommand } from "@aws-sdk/client-dynamodb";
import { connectDynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = connectDynamo();
  const { firstName, lastName, gymId } = event.request.userAttributes;
  if (firstName && lastName && gymId) {
    await client.send(
      new TransactWriteItemsCommand({
        TransactItems: [
          {
            Put: {
              TableName: process.env.DYNAMO_TABLE_NAME,
              Item: {
                part_id: { S: "USERS" },
                sort_id: { S: `USER#${event.userName}` },
                firstName: { S: event.request.userAttributes.firstName },
                lastName: { S: event.request.userAttributes.lastName },
                gymId: { S: event.request.userAttributes.gymId },
              },
            },
          },
          {
            Put: {
              TableName: process.env.DYNAMO_TABLE_NAME,
              Item: {
                part_id: { S: `GYM#${event.request.userAttributes.gymId}` },
                sort_id: { S: `USER#${event.userName}` },
                firstName: { S: event.request.userAttributes.firstName },
                lastName: { S: event.request.userAttributes.lastName },
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
