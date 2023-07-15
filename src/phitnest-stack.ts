import { Stack } from "aws-cdk-lib";
import { ApiStack, CognitoStack, DynamoStack, S3Stack } from "components";
import { Construct } from "constructs";
import * as path from "path";

const DEPLOYMENT_ENV = process.env.DEPLOYMENT_ENV || "dev";

export class PhitnestStack extends Stack {
  constructor(scope: Construct) {
    super(scope, `phitnest-stack-${DEPLOYMENT_ENV}`);

    const apiSrcDir = path.join(process.cwd(), "phitnest-api");
    const lambdaSrcDir = path.join(apiSrcDir, "src");
    const apiDeploymentDir = path.join(process.cwd(), "dist");
    const nodeModulesDir = path.join(apiSrcDir, "node_modules");
    const commonDir = path.join(lambdaSrcDir, "common");

    const dynamo = new DynamoStack(scope, {
      deploymentEnv: DEPLOYMENT_ENV,
    });

    const cognito = new CognitoStack(scope, {
      deploymentEnv: DEPLOYMENT_ENV,
      cognitoHookSrcDir: path.join(lambdaSrcDir, "cognito_hooks"),
      nodeModulesDir: nodeModulesDir,
      commonDir: commonDir,
      cognitoHookDeploymentDir: path.join(apiDeploymentDir, "cognito_hooks"),
      dynamoTableName: dynamo.tableName,
      dynamoTableRole: dynamo.tableRole,
    });

    const s3 = new S3Stack(scope, {
      deploymentEnv: DEPLOYMENT_ENV,
      identityPoolId: cognito.userIdentityPoolId,
    });

    new ApiStack(scope, {
      deploymentEnv: DEPLOYMENT_ENV,
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
    });
  }
}
