import {
  AttributeType,
  BillingMode,
  CfnGlobalTable,
} from "@aws-cdk/aws-dynamodb";
import { IResolvable, RemovalPolicy } from "@aws-cdk/core";
import { DEPLOYMENT_ENV, PhitnestApiStack } from "./phitnest-api-stack";

const PART_KEY = "part_id";
const SORT_KEY = "sort_id";

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
      tableName: `PhitnestTable-${DEPLOYMENT_ENV}`,
      billingMode: BillingMode.PAY_PER_REQUEST,
      keySchema: [
        {
          attributeName: PART_KEY,
          keyType: "HASH",
        },
        {
          attributeName: SORT_KEY,
          keyType: "RANGE",
        },
      ],
      attributeDefinitions: [
        {
          attributeName: PART_KEY,
          attributeType: AttributeType.STRING,
        },
        {
          attributeName: SORT_KEY,
          attributeType: AttributeType.STRING,
        },
      ],
    });
    this.table.applyRemovalPolicy(RemovalPolicy.DESTROY);
  }
}
