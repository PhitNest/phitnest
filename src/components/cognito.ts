import { RemovalPolicy } from "aws-cdk-lib";
import {
  AccountRecovery,
  CfnIdentityPool,
  UserPool,
  UserPoolClient,
  UserPoolEmail,
} from "aws-cdk-lib/aws-cognito";
import { Role } from "aws-cdk-lib/aws-iam";
import { Code, Function, Runtime } from "aws-cdk-lib/aws-lambda";
import { Construct } from "constructs";
import { createDeploymentPackage } from "../utils";
import * as path from "path";

export interface CognitoStackProps {
  deploymentEnv: string;
  cognitoHookDeploymentDir: string;
  cognitoHookSrcDir: string;
  nodeModulesDir: string;
  commonDir: string;
  dynamoTableName: string;
  dynamoTableRole: Role;
}

export class CognitoStack extends Construct {
  public readonly userClientId: string;
  public readonly adminClientId: string;
  public readonly userIdentityPoolId: string;
  public readonly userPool: UserPool;
  public readonly adminPool: UserPool;
  private readonly props: CognitoStackProps;

  constructor(scope: Construct, props: CognitoStackProps) {
    super(scope, `phitnest-cognito-stack-${props.deploymentEnv}`);
    this.props = props;
    const emailConfig = UserPoolEmail.withSES({
      fromEmail: "verify@phitnest.com",
      fromName: "PhitNest Verification",
      replyTo: "verify@phitnest.com",
      sesVerifiedDomain: "phitnest.com",
      sesRegion: "us-east-1",
    });
    const userPresignupDeploymentDir = path.join(
      props.cognitoHookDeploymentDir,
      "user_presignup"
    );
    createDeploymentPackage(
      path.join(props.cognitoHookSrcDir, "user-presignup.ts"),
      props.nodeModulesDir,
      props.commonDir,
      userPresignupDeploymentDir
    );
    const userPoolPrefix = "PhitnestUser";
    const userPresignupHook = this.createPresignupHook(
      scope,
      props.dynamoTableName,
      props.dynamoTableRole,
      userPoolPrefix,
      userPresignupDeploymentDir
    );
    this.userPool = new UserPool(
      scope,
      `${userPoolPrefix}Pool-${props.deploymentEnv}`,
      {
        userPoolName: `Phitnest-User-Pool-${props.deploymentEnv}`,
        selfSignUpEnabled: true,
        signInAliases: {
          email: true,
          username: false,
        },
        accountRecovery: AccountRecovery.EMAIL_ONLY,
        email: emailConfig,
        standardAttributes: {
          email: {
            mutable: true,
            required: true,
          },
        },
        lambdaTriggers: {
          preSignUp: userPresignupHook,
        },
      }
    );
    this.userPool.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const userClient = this.createClient(scope, this.userPool, userPoolPrefix);
    userClient.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.userClientId = userClient.userPoolClientId;
    const userIdentityPool = new CfnIdentityPool(
      scope,
      `${userPoolPrefix}IdentityPool-${props.deploymentEnv}`,
      {
        identityPoolName: `Phitnest-User-Identity-Pool-${props.deploymentEnv}`,
        allowUnauthenticatedIdentities: false,
        cognitoIdentityProviders: [
          {
            providerName: this.userPool.userPoolProviderName,
            clientId: userClient.userPoolClientId,
          },
        ],
      }
    );
    userIdentityPool.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.userIdentityPoolId = userIdentityPool.ref;
    const adminPresignupDeploymentDir = path.join(
      props.cognitoHookDeploymentDir,
      "admin_presignup"
    );
    createDeploymentPackage(
      path.join(props.cognitoHookSrcDir, "admin-presignup.ts"),
      props.nodeModulesDir,
      props.commonDir,
      adminPresignupDeploymentDir
    );
    const adminPoolPrefix = "PhitnestAdmin";
    const adminPresignupHook = this.createPresignupHook(
      scope,
      props.dynamoTableName,
      props.dynamoTableRole,
      adminPoolPrefix,
      adminPresignupDeploymentDir
    );
    this.adminPool = new UserPool(
      scope,
      `${adminPoolPrefix}Pool-${props.deploymentEnv}`,
      {
        userPoolName: `Phitnest-Admin-Pool-${props.deploymentEnv}`,
        selfSignUpEnabled: true,
        signInAliases: {
          email: true,
          username: false,
        },
        accountRecovery: AccountRecovery.EMAIL_ONLY,
        email: emailConfig,
        standardAttributes: {
          email: {
            mutable: true,
            required: true,
          },
        },
        lambdaTriggers: {
          preSignUp: adminPresignupHook,
        },
      }
    );
    this.adminPool.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const adminClient = this.createClient(
      scope,
      this.adminPool,
      adminPoolPrefix
    );
    adminClient.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.adminClientId = adminClient.userPoolClientId;
  }

  private createPresignupHook(
    scope: Construct,
    dynamoTableName: string,
    apiRole: Role,
    prefix: string,
    deploymentDir: string
  ) {
    const hook = new Function(
      scope,
      `${prefix}Presignup-${this.props.deploymentEnv}`,
      {
        runtime: Runtime.NODEJS_16_X,
        handler: `index.invoke`,
        environment: {
          DYNAMO_TABLE_NAME: dynamoTableName,
        },
        code: Code.fromAsset(deploymentDir),
        role: apiRole,
      }
    );
    hook.applyRemovalPolicy(RemovalPolicy.DESTROY);
    return hook;
  }

  private createClient(
    scope: Construct,
    pool: UserPool,
    prefix: string
  ): UserPoolClient {
    const client = new UserPoolClient(
      scope,
      `${prefix}Client-${this.props.deploymentEnv}`,
      { userPool: pool }
    );
    client.applyRemovalPolicy(RemovalPolicy.DESTROY);
    return client;
  }
}
