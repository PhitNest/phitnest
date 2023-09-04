import { CfnOutput, Stack } from "aws-cdk-lib";
import { ApiStack, CognitoStack, DynamoStack, S3Stack } from "./components";
import { Construct } from "constructs";
import * as path from "path";

const kDeploymentEnv = process.env.DEPLOYMENT_ENV || "dev";
const kRegion = "us-east-1";
const kBackupRegion = "us-west-1";
const kApiRoute53Arn = `arn:aws:acm:${kRegion}:235601651768:certificate/030219b7-d13c-4f07-90a2-baf20ba90837`;

export class PhitnestStack extends Stack {
  constructor(scope: Construct) {
    super(scope, `phitnest-stack-${kDeploymentEnv}`);

    const apiDir = path.join(process.cwd(), "..", "..", "packages", "api");

    const dynamo = new DynamoStack(this, {
      deploymentEnv: kDeploymentEnv,
      region: kRegion,
      backupRegion: kBackupRegion,
    });

    const cognito = new CognitoStack(this, {
      deploymentEnv: kDeploymentEnv,
      cognitoHooksDir: path.join(apiDir, "cognito-hooks"),
      dynamoTableName: dynamo.tableName,
      dynamoTableArn: dynamo.tableArn,
      dynamoTableRole: dynamo.tableRole,
      region: kRegion,
    });

    const s3 = new S3Stack(this, {
      deploymentEnv: kDeploymentEnv,
      identityPoolId: cognito.userIdentityPoolId,
    });

    const api = new ApiStack(this, {
      deploymentEnv: kDeploymentEnv,
      apiDir: apiDir,
      userPool: cognito.userPool,
      userClientId: cognito.userClientId,
      adminClientId: cognito.adminClientId,
      adminPool: cognito.adminPool,
      userIdentityPoolId: cognito.userIdentityPoolId,
      dynamoTableName: dynamo.tableName,
      dynamoTableRole: dynamo.tableRole,
      userBucketName: s3.userBucketName,
      region: kRegion,
      apiRoute53CertificateArn:
        kDeploymentEnv === "prod" ? kApiRoute53Arn : undefined,
    });

    new CfnOutput(this, "UserPoolId", {
      value: cognito.userPool.userPoolId,
    });
    new CfnOutput(this, "ClientId", {
      value: cognito.userClientId,
    });
    new CfnOutput(this, "AdminPoolId", {
      value: cognito.adminPool.userPoolId,
    });
    new CfnOutput(this, "AdminClientId", {
      value: cognito.adminClientId,
    });
    new CfnOutput(this, "IdentityPoolId", {
      value: cognito.userIdentityPoolId,
    });
    new CfnOutput(this, "UserBucketName", {
      value: s3.userBucketName,
    });
    new CfnOutput(this, "Region", {
      value: kRegion,
    });
    new CfnOutput(this, "Host", {
      value: api.restApi.url,
    });
    new CfnOutput(this, "Port", {
      value: "443",
    });
  }
}
