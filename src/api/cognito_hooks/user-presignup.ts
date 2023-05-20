import {
  QueryCommand,
  TransactWriteItemsCommand,
} from "@aws-sdk/client-dynamodb";
import { connectDynamo } from "api/common/utils";
import { PreSignUpTriggerEvent } from "aws-lambda";

export async function invoke(event: PreSignUpTriggerEvent) {
  const client = connectDynamo();
  const { firstName, lastName, gymId } = event.request.userAttributes;
  if (firstName && lastName && gymId) {
    const gymQueryResult = await client.send(
      new QueryCommand({
        TableName: process.env.DYNAMO_TABLE_NAME,
        KeyConditions: {
          part_id: {
            ComparisonOperator: "EQ",
            AttributeValueList: [{ S: "GYMS" }],
          },
          sort_id: {
            ComparisonOperator: "EQ",
            AttributeValueList: [{ S: `GYM#${gymId}` }],
          },
        },
      })
    );
    if (gymQueryResult.Items && gymQueryResult.Items.length === 1) {
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
      throw new Error("No such gym");
    }
  } else {
    throw new Error("Missing required attributes");
  }
}
