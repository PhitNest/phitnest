import {
  AttributeType,
  BillingMode,
  CfnGlobalTable,
} from "@aws-cdk/aws-dynamodb";
import { DEPLOYMENT_ENV, PhitnestApiStack } from "./phitnest-api-stack";
import { IResolvable, RemovalPolicy } from "@aws-cdk/core";

const DYNAMODB_REPLICAS:
  | Array<CfnGlobalTable.ReplicaSpecificationProperty | IResolvable>
  | IResolvable =
  DEPLOYMENT_ENV == "prod"
    ? [
        {
          region: "us-east-1",
          pointInTimeRecoverySpecification: {
            pointInTimeRecoveryEnabled: true,
          },
        },
        {
          region: "us-west-1",
          pointInTimeRecoverySpecification: {
            pointInTimeRecoveryEnabled: true,
          },
        },
      ]
    : [{ region: "us-east-1" }];

export class DynamoDBStack {
  constructor(scope: PhitnestApiStack) {
    const gymUserTable = new CfnGlobalTable(
      scope,
      `PhitnestGymUserTable-${DEPLOYMENT_ENV}`,
      {
        replicas: DYNAMODB_REPLICAS,
        billingMode: BillingMode.PAY_PER_REQUEST,
        keySchema: [
          {
            attributeName: "gym_user_id",
            keyType: "HASH",
          },
          {
            attributeName: "gym_user_secondary_id",
            keyType: "RANGE",
          },
        ],
        attributeDefinitions: [
          {
            attributeName: "user_cognito_id",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "user_first_name",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "user_last_name",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gym_id",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gym_name",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gym_address",
            attributeType: AttributeType.STRING,
          },
        ],
      }
    );
    gymUserTable.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const conversationMessageTable = new CfnGlobalTable(
      scope,
      `PhitnestConversationMessageTable-${DEPLOYMENT_ENV}`,
      {
        replicas: DYNAMODB_REPLICAS,
        billingMode: BillingMode.PAY_PER_REQUEST,
        keySchema: [
          {
            attributeName: "conversation_message_id",
            keyType: "HASH",
          },
          {
            attributeName: "conversation_message_secondary_id",
            keyType: "RANGE",
          },
        ],
        attributeDefinitions: [
          {
            attributeName: "message_id",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "message_text",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "message_time",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "conversation_id",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "user_data",
            attributeType: AttributeType.STRING,
          },
        ],
      }
    );
    conversationMessageTable.applyRemovalPolicy(RemovalPolicy.DESTROY);
  }
}
