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
  region: string;
  backupRegion: string;
}

const kPartKey = "pk";
const kSortKey = "sk";

export class DynamoStack extends Construct {
  public readonly tableName: string;
  public readonly tableRole: Role;
  public readonly tableArn: string;

  constructor(scope: Construct, props: DynamoStackProps) {
    super(scope, `phitnest-dynamo-stack-${props.deploymentEnv}`);

    const dynamoReplicas:
      | Array<CfnGlobalTable.ReplicaSpecificationProperty | IResolvable>
      | IResolvable =
      props.deploymentEnv == "prod"
        ? [
            {
              region: props.region,
              pointInTimeRecoverySpecification: {
                pointInTimeRecoveryEnabled: true,
              },
            },
            {
              region: props.backupRegion,
              pointInTimeRecoverySpecification: {
                pointInTimeRecoveryEnabled: true,
              },
            },
          ]
        : [{ region: props.region }];

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
        globalSecondaryIndexes: [
          {
            indexName: "inverted",
            keySchema: [
              {
                attributeName: kSortKey,
                keyType: "HASH",
              },
              {
                attributeName: kPartKey,
                keyType: "RANGE",
              },
            ],
            projection: {
              projectionType: "ALL",
            },
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
      },
    );
    table.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.tableArn = table.attrArn;
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
                resources: [table.attrArn, `${table.attrArn}/index/inverted`],
              }),
            ],
          }),
        },
      },
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
