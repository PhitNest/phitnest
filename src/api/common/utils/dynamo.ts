import { DynamoDBClient } from "@aws-sdk/client-dynamodb";

export function connectDynamo(): DynamoDBClient {
  return new DynamoDBClient({
    region: process.env.AWS_REGION,
  });
}

export type AdminCognitoClaims = {
  email: string;
  sub: string;
};

export type UserCognitoClaims = {
  email: string;
  sub: string;
  firstName: string;
  lastName: string;
};
