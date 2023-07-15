import { IResolvable, RemovalPolicy } from "aws-cdk-lib";
import {
  AttributeType,
  BillingMode,
  CfnGlobalTable,
} from "aws-cdk-lib/aws-dynamodb";
import {
  Effect,
  PolicyDocument,
  PolicyStatement,
  Role,
  ServicePrincipal,
} from "aws-cdk-lib/aws-iam";
import { Construct } from "constructs";

export interface DynamoStackProps {
  deploymentEnv: string;
}

const kPartKey = "part_id";
const kSortKey = "sort_id";

export class DynamoStack extends Construct {
  public readonly tableName: string;
  public readonly tableRole: Role;

  constructor(scope: Construct, props: DynamoStackProps) {
    super(scope, `phitnest-dynamo-stack-${props.deploymentEnv}`);

    const dynamoReplicas:
      | Array<CfnGlobalTable.ReplicaSpecificationProperty | IResolvable>
      | IResolvable =
      props.deploymentEnv == "prod"
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

    const table = new CfnGlobalTable(
      scope,
      `PhitnestTable-${props.deploymentEnv}`,
      {
        replicas: dynamoReplicas,
        tableName: `PhitnestTable-${props.deploymentEnv}`,
        billingMode: BillingMode.PAY_PER_REQUEST,
        keySchema: [
          {
            attributeName: kPartKey,
            keyType: "HASH",
          },
          {
            attributeName: kSortKey,
            keyType: "RANGE",
          },
        ],
        attributeDefinitions: [
          {
            attributeName: kPartKey,
            attributeType: AttributeType.STRING,
          },
          {
            attributeName: kSortKey,
            attributeType: AttributeType.STRING,
          },
        ],
      }
    );
    table.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.tableRole = new Role(
      scope,
      `PhitnestDynamoTableRole-${props.deploymentEnv}`,
      {
        assumedBy: new ServicePrincipal("lambda.amazonaws.com"),
        inlinePolicies: {
          dynamoAccess: new PolicyDocument({
            statements: [
              new PolicyStatement({
                sid: "AllowDynamoAccessForApi",
                effect: Effect.ALLOW,
                actions: ["dynamodb:*"],
                resources: [table.attrArn],
              }),
            ],
          }),
        },
      }
    );
    this.tableRole.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const tableName = table.tableName;
    if (tableName) {
      this.tableName = tableName;
    } else {
      throw new Error("Table name is undefined");
    }
  }
}
