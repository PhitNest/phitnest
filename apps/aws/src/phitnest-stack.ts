import { Stack } from "aws-cdk-lib";
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

    const srcDir = path.join(process.cwd(), "phitnest-api");
    const apiSrcDir = path.join(srcDir, "src");
    const apiDeploymentDir = path.join(process.cwd(), "dist");
    const nodeModulesDir = path.join(srcDir, "node_modules");
    const commonDir = path.join(apiSrcDir, "common");

    const dynamo = new DynamoStack(this, {
      deploymentEnv: kDeploymentEnv,
      region: kRegion,
      backupRegion: kBackupRegion,
    });

    const cognito = new CognitoStack(this, {
      deploymentEnv: kDeploymentEnv,
      cognitoHookSrcDir: path.join(apiSrcDir, "cognito_hooks"),
      nodeModulesDir: nodeModulesDir,
      commonDir: commonDir,
      cognitoHookDeploymentDir: path.join(apiDeploymentDir, "cognito_hooks"),
      dynamoTableName: dynamo.tableName,
      dynamoTableRole: dynamo.tableRole,
      region: kRegion,
    });

    const s3 = new S3Stack(this, {
      deploymentEnv: kDeploymentEnv,
      identityPoolId: cognito.userIdentityPoolId,
    });

    new ApiStack(this, {
      deploymentEnv: kDeploymentEnv,
      apiSrcDir: apiSrcDir,
      nodeModulesDir: nodeModulesDir,
      commonDir: commonDir,
      apiDeploymentDir: apiDeploymentDir,
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
  }
}
