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
    const dynamoTable = new CfnGlobalTable(
      scope,
      `PhitnestTable-${DEPLOYMENT_ENV}`,
      {
        replicas: DYNAMODB_REPLICAS,
        billingMode: BillingMode.PAY_PER_REQUEST,
        keySchema: [
          {
            attributeName: "gymId",
            keyType: "HASH",
          },
          {
            attributeName: "gymName",
            keyType: "RANGE",
          },
          {
            attributeName: "userCognitoId",
            keyType: "RANGE",
          },
        ],
        attributeDefinitions: [
          {
            attributeName: "gymId",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gymName",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "userCognitoId",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "firstName",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "lastName",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gymStreet",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gymState",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gymCity",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gymZipCode",
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: "gymLongitude",
            attributeType: AttributeType.NUMBER,
          },
          {
            attributeName: "gymLatitude",
            attributeType: AttributeType.NUMBER,
          },
        ],
      }
    );
    dynamoTable.applyRemovalPolicy(RemovalPolicy.DESTROY);
  }
}
