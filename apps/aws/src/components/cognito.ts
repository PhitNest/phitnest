import { RemovalPolicy } from "aws-cdk-lib";
import {
  AccountRecovery,
  CfnIdentityPool,
  StringAttribute,
  UserPool,
  UserPoolClient,
  UserPoolEmail,
} from "aws-cdk-lib/aws-cognito";
import {
  Effect,
  PolicyDocument,
  PolicyStatement,
  Role,
  ServicePrincipal,
} from "aws-cdk-lib/aws-iam";
import { Code, Function, Runtime } from "aws-cdk-lib/aws-lambda";
import { Construct } from "constructs";
import * as path from "path";

export interface CognitoStackProps {
  deploymentEnv: string;
  cognitoHooksDir: string;
  dynamoTableName: string;
  dynamoTableArn: string;
  dynamoTableRole: Role;
  region: string;
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
      sesRegion: props.region,
    });
    const userPresignupHook = new Function(
      scope,
      `UserPresignup-${this.props.deploymentEnv}`,
      {
        runtime: Runtime.NODEJS_16_X,
        handler: `index.invoke`,
        environment: {
          DYNAMO_TABLE_NAME: props.dynamoTableName,
        },
        code: Code.fromAsset(
          path.join(
            props.cognitoHooksDir,
            "user-presignup",
            "dist",
            "index.zip",
          ),
        ),
        role: props.dynamoTableRole,
      },
    );
    userPresignupHook.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const userPostConfirmationRole = new Role(
      this,
      `UserPostConfirmationRole-${this.props.deploymentEnv}`,
      {
        assumedBy: new ServicePrincipal("lambda.amazonaws.com"),
        inlinePolicies: {
          dynamoAccess: new PolicyDocument({
            statements: [
              new PolicyStatement({
                sid: "AllowDynamoAccessForApi",
                effect: Effect.ALLOW,
                actions: ["dynamodb:*"],
                resources: [
                  props.dynamoTableArn,
                  `${props.dynamoTableArn}/index/inverted`,
                ],
              }),
              new PolicyStatement({
                sid: "CognitoUpdate",
                effect: Effect.ALLOW,
                actions: ["cognito-idp:AdminUpdateUserAttributes"],
                resources: ["*"],
              }),
            ],
          }),
        },
      },
    );
    userPostConfirmationRole.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const userPostConfirmationHook = new Function(
      scope,
      `UserPostConfirmation-${this.props.deploymentEnv}`,
      {
        runtime: Runtime.NODEJS_16_X,
        handler: `index.invoke`,
        environment: {
          DYNAMO_TABLE_NAME: props.dynamoTableName,
        },
        code: Code.fromAsset(
          path.join(
            props.cognitoHooksDir,
            "user-postconfirmation",
            "dist",
            "index.zip",
          ),
        ),
        role: userPostConfirmationRole,
      },
    );
    userPostConfirmationHook.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.userPool = new UserPool(scope, `UserPool-${props.deploymentEnv}`, {
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
      customAttributes: {
        gymId: new StringAttribute({ mutable: true }),
      },
      lambdaTriggers: {
        preSignUp: userPresignupHook,
        postConfirmation: userPostConfirmationHook,
      },
    });
    this.userPool.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const userClient = this.createClient(scope, this.userPool, "User");
    userClient.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.userClientId = userClient.userPoolClientId;
    const userIdentityPool = new CfnIdentityPool(
      scope,
      `UserIdentityPool-${props.deploymentEnv}`,
      {
        identityPoolName: `Phitnest-User-Identity-Pool-${props.deploymentEnv}`,
        allowUnauthenticatedIdentities: false,
        cognitoIdentityProviders: [
          {
            providerName: this.userPool.userPoolProviderName,
            clientId: userClient.userPoolClientId,
          },
        ],
      },
    );
    userIdentityPool.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.userIdentityPoolId = userIdentityPool.ref;
    this.adminPool = new UserPool(scope, `AdminPool-${props.deploymentEnv}`, {
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
    });
    this.adminPool.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const adminClient = this.createClient(scope, this.adminPool, "Admin");
    adminClient.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.adminClientId = adminClient.userPoolClientId;
  }

  private createClient(
    scope: Construct,
    pool: UserPool,
    prefix: string,
  ): UserPoolClient {
    const client = new UserPoolClient(
      scope,
      `${prefix}Client-${this.props.deploymentEnv}`,
      { userPool: pool },
    );
    client.applyRemovalPolicy(RemovalPolicy.DESTROY);
    return client;
  }
}
