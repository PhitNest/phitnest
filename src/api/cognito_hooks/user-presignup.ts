import {
  QueryCommand,
  TransactWriteItemsCommand,
} from "@aws-sdk/client-dynamodb";
import { connectDynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = connectDynamo();
  const { firstName, lastName, inviterEmail } = event.request.userAttributes;
  if (firstName && lastName && inviterEmail) {
    const inviteQuery = await client.send(
      new QueryCommand({
        TableName: process.env.DYNAMO_TABLE_NAME,
        KeyConditions: {
          part_id: {
            ComparisonOperator: "EQ",
            AttributeValueList: [{ S: `INVITE#${inviterEmail}` }],
          },
          sort_id: {
            ComparisonOperator: "EQ",
            AttributeValueList: [{ S: `RECEIVER#${event.userName}` }],
          },
        },
      })
    );
    if (inviteQuery.Items && inviteQuery.Items.length === 1) {
      const gymId = inviteQuery.Items[0]["gymId"].S;
      const inviterId = inviteQuery.Items[0]["inviterId"].S;
      if (gymId) {
        const 
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
        return event;
      } else {
        throw new Error(`The invite from: ${inviterEmail} is missing a gymId`);
      }
    } else {
      throw new Error(`You have not received an invite from: ${inviterEmail}`);
    }
  } else {
    throw new Error("Missing required attributes");
  }
}
