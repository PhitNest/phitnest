import {
  AttributeType,
  BillingMode,
  CfnGlobalTable,
} from "@aws-cdk/aws-dynamodb";
import { IResolvable, RemovalPolicy } from "@aws-cdk/core";
import { DEPLOYMENT_ENV, PhitnestApiStack } from "./phitnest-api-stack";

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
            attributeName: "gym_user_part",
            keyType: "HASH",
          },
          {
            attributeName: "gym_user_sort",
            keyType: "RANGE",
          },
        ],
        attributeDefinitions: [
          {
            attributeName: "gym_user_part",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gym_user_sort",
            attributeType: AttributeType.STRING,
          },
        ],
      }
    );
    gymUserTable.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const conversationsTable = new CfnGlobalTable(
      scope,
      `PhitnestConversationTable-${DEPLOYMENT_ENV}`,
      {
        replicas: DYNAMODB_REPLICAS,
        billingMode: BillingMode.PAY_PER_REQUEST,
        keySchema: [
          {
            attributeName: "conversation_part",
            keyType: "HASH",
          },
          {
            attributeName: "conversation_sort",
            keyType: "RANGE",
          },
        ],
        attributeDefinitions: [
          {
            attributeName: "conversation_part",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "conversation_sort",
            attributeType: AttributeType.STRING,
          },
        ],
      }
    );
    conversationsTable.applyRemovalPolicy(RemovalPolicy.DESTROY);
  }
}
