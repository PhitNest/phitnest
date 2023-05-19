import { DynamoDBClient } from "@aws-sdk/client-dynamodb";

export function connectDynamo(): DynamoDBClient {
  return new DynamoDBClient({
    region: process.env.AWS_REGION,
  });
}
