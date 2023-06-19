import {
  AccountRecovery,
  CfnIdentityPool,
  UserPool,
  UserPoolClient,
  UserPoolEmail,
} from "@aws-cdk/aws-cognito";
import { RemovalPolicy } from "@aws-cdk/core";
import { HttpUserPoolAuthorizer } from "@aws-cdk/aws-apigatewayv2-authorizers";
import { Code, Function, Runtime } from "@aws-cdk/aws-lambda";
import { Role } from "@aws-cdk/aws-iam";
import { DEPLOYMENT_ENV, PhitnestApiStack } from "./phitnest-api-stack";
import { createDeploymentPackage } from "./lambda-deployment";
import { DynamoDBStack } from "./dynamodb-stack";
import * as path from "path";

type CognitoStackParams = {
  cognitoHooksDir: string;
  lambdaDeploymentDir: string;
  nodeModulesDir: string;
  commonDeploymentDir: string;
  dynamoDbStack: DynamoDBStack;
  lambdaRole: Role;
};

export class CognitoStack {
  public readonly userAuthorizer: HttpUserPoolAuthorizer;
  public readonly adminAuthorizer: HttpUserPoolAuthorizer;
  public readonly userPool: UserPool;
  public readonly adminPool: UserPool;
  public readonly userClient: UserPoolClient;
  public readonly adminClient: UserPoolClient;
  public readonly userIdentityPool: CfnIdentityPool;
  private readonly params: CognitoStackParams;

  constructor(scope: PhitnestApiStack, params: CognitoStackParams) {
    this.params = params;
    const hookDeploymentDir = path.join(
      params.lambdaDeploymentDir,
      "cognito_hooks"
    );
    const emailConfig = UserPoolEmail.withSES({
      fromEmail: "verify@phitnest.com",
      fromName: "PhitNest Verification",
      replyTo: "verify@phitnest.com",
      sesVerifiedDomain: "phitnest.com",
    });
    const userPresignupDeploymentDir = path.join(
      hookDeploymentDir,
      "user_presignup"
    );
    const userPoolPrefix = "PhitnestUser";
    createDeploymentPackage(
      path.join(this.params.cognitoHooksDir, "user-presignup.ts"),
      userPresignupDeploymentDir,
      this.params.nodeModulesDir,
      this.params.commonDeploymentDir
    );
    const userPresignupHook = this.createPresignupHook(
      scope,
      params.dynamoDbStack,
      params.lambdaRole,
      userPoolPrefix,
      userPresignupDeploymentDir
    );
    this.userPool = new UserPool(
      scope,
      `${userPoolPrefix}Pool-${DEPLOYMENT_ENV}`,
      {
        userPoolName: `Phitnest-User-Pool-${DEPLOYMENT_ENV}`,
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
    [this.userClient, this.userAuthorizer] = this.createClient(
      scope,
      this.userPool,
      userPoolPrefix
    );
    this.userIdentityPool = new CfnIdentityPool(
      scope,
      `PhitnestUserIdentityPool-${DEPLOYMENT_ENV}`,
      {
        identityPoolName: `Phitnest-User-Identity-Pool-${DEPLOYMENT_ENV}`,
        allowUnauthenticatedIdentities: false,
        cognitoIdentityProviders: [
          {
            providerName: this.userPool.userPoolProviderName,
            clientId: this.userClient.userPoolClientId,
          },
        ],
      }
    );
    this.userIdentityPool.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const adminPresignupDeploymentDir = path.join(
      hookDeploymentDir,
      "admin_presignup"
    );
    const adminPoolPrefix = "PhitnestAdmin";
    createDeploymentPackage(
      path.join(this.params.cognitoHooksDir, "admin-presignup.ts"),
      adminPresignupDeploymentDir,
      this.params.nodeModulesDir,
      this.params.commonDeploymentDir
    );
    const adminPresignupHook = this.createPresignupHook(
      scope,
      params.dynamoDbStack,
      params.lambdaRole,
      adminPoolPrefix,
      adminPresignupDeploymentDir
    );
    this.adminPool = new UserPool(
      scope,
      `${adminPoolPrefix}Pool-${DEPLOYMENT_ENV}`,
      {
        userPoolName: `Phitnest-Admin-Pool-${DEPLOYMENT_ENV}`,
        selfSignUpEnabled: false,
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
    [this.adminClient, this.adminAuthorizer] = this.createClient(
      scope,
      this.adminPool,
      adminPoolPrefix
    );
  }

  private createPresignupHook(
    scope: PhitnestApiStack,
    dynamo: DynamoDBStack,
    lambdaRole: Role,
    prefix: string,
    deploymentDir: string
  ) {
    return new Function(scope, `${prefix}Presignup-${DEPLOYMENT_ENV}`, {
      runtime: Runtime.NODEJS_16_X,
      handler: `index.invoke`,
      environment: {
        DYNAMO_TABLE_NAME:
          dynamo.table.tableName || `PhitnestTable-${DEPLOYMENT_ENV}`,
      },
      code: Code.fromAsset(deploymentDir),
      role: lambdaRole,
    });
  }

  private createClient(
    scope: PhitnestApiStack,
    pool: UserPool,
    prefix: string
  ): [UserPoolClient, HttpUserPoolAuthorizer] {
    const client = new UserPoolClient(
      scope,
      `${prefix}Client-${DEPLOYMENT_ENV}`,
      { userPool: pool }
    );
    client.applyRemovalPolicy(RemovalPolicy.DESTROY);
    return [
      client,
      new HttpUserPoolAuthorizer(
        `${prefix}Authorizer-${DEPLOYMENT_ENV}`,
        pool,
        {
          userPoolClients: [client],
          identitySource: ["$request.header.Authorization"],
        }
      ),
    ];
  }
}
