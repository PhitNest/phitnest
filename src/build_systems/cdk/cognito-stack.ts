import {
  AccountRecovery,
  StringAttribute,
  UserPool,
  UserPoolClient,
  UserPoolEmail,
} from "@aws-cdk/aws-cognito";
import { RemovalPolicy } from "@aws-cdk/core";
import { DEPLOYMENT_ENV, PhitnestApiStack } from "./phitnest-api-stack";
import { HttpUserPoolAuthorizer } from "@aws-cdk/aws-apigatewayv2-authorizers";
import { Code, Function, Runtime } from "@aws-cdk/aws-lambda";
import { createDeploymentPackage } from "./lambda-deployment";
import * as path from "path";

type CognitoStackParams = {
  cognitoHooksDir: string;
  lambdaDeploymentDir: string;
  nodeModulesDir: string;
  commonDeploymentDir: string;
};

export class CognitoStack {
  public readonly userAuthorizer: HttpUserPoolAuthorizer;
  public readonly adminAuthorizer: HttpUserPoolAuthorizer;
  public readonly userPool: UserPool;
  public readonly adminPool: UserPool;
  public readonly userClient: UserPoolClient;
  public readonly adminClient: UserPoolClient;
  private readonly params: CognitoStackParams;

  constructor(scope: PhitnestApiStack, params: CognitoStackParams) {
    this.params = params;
    const hookDeploymentDir = path.join(
      params.lambdaDeploymentDir,
      "cognito_hooks"
    );
    const nameAttribute = new StringAttribute({
      mutable: true,
      minLen: 1,
      maxLen: 24,
    });
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
        customAttributes: {
          firstName: nameAttribute,
          lastName: nameAttribute,
          gymId: new StringAttribute({ mutable: true }),
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
        customAttributes: {
          firstName: nameAttribute,
          lastName: nameAttribute,
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
    prefix: string,
    deploymentDir: string
  ) {
    return new Function(scope, `${prefix}Presignup-${DEPLOYMENT_ENV}`, {
      runtime: Runtime.NODEJS_16_X,
      handler: `index.invoke`,
      environment: {
        DYNAMO_TABLE_NAME:
          scope.dynamo.table.tableName || `PhitnestTable-${DEPLOYMENT_ENV}`,
      },
      code: Code.fromAsset(deploymentDir),
      role: scope.lambdaRole,
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
