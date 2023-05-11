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
  public readonly table;

  constructor(scope: PhitnestApiStack) {
    this.table = new CfnGlobalTable(scope, `PhitnestTable-${DEPLOYMENT_ENV}`, {
      replicas: DYNAMODB_REPLICAS,
      tableName: `Phitnest-${DEPLOYMENT_ENV}`,
      billingMode: BillingMode.PAY_PER_REQUEST,
      keySchema: [
        {
          attributeName: "part_id",
          keyType: "HASH",
        },
        {
          attributeName: "sort_id",
          keyType: "RANGE",
        },
      ],
      attributeDefinitions: [
        {
          attributeName: "part_id",
          attributeType: AttributeType.STRING,
        },
        {
          attributeName: "sort_id",
          attributeType: AttributeType.STRING,
        },
      ],
    });
    this.table.applyRemovalPolicy(RemovalPolicy.DESTROY);
  }
}
