import { RemovalPolicy } from "aws-cdk-lib";
import { CfnIdentityPoolRoleAttachment } from "aws-cdk-lib/aws-cognito";
import {
  Effect,
  FederatedPrincipal,
  PolicyStatement,
  Role,
} from "aws-cdk-lib/aws-iam";
import { Bucket, HttpMethods } from "aws-cdk-lib/aws-s3";
import { Construct } from "constructs";

interface S3StackProps {
  deploymentEnv: string;
  identityPoolId: string;
}

export class S3Stack extends Construct {
  public readonly userBucketName: string;

  constructor(scope: Construct, props: S3StackProps) {
    super(scope, `phitnest-s3-stack-${props.deploymentEnv}`);
    const userBucket = new Bucket(
      scope,
      `PhitnestBucket-${props.deploymentEnv}`,
      {
        bucketName: `phitnest-user-bucket-${props.deploymentEnv}`,
        autoDeleteObjects: true,
        removalPolicy: RemovalPolicy.DESTROY,
        cors: [
          {
            allowedHeaders: ["*"],
            allowedMethods: [
              HttpMethods.POST,
              HttpMethods.PUT,
              HttpMethods.GET,
              HttpMethods.DELETE,
            ],
            allowedOrigins: ["*"],
            exposedHeaders: [
              "x-amz-server-side-encryption",
              "x-amz-request-id",
              "x-amz-id-2",
              "ETag",
            ],
          },
        ],
      },
    );
    userBucket.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.userBucketName = userBucket.bucketName;

    const authenticatedRole = new Role(
      scope,
      `CognitoDefaultAuthenticatedRole-${props.deploymentEnv}`,
      {
        assumedBy: new FederatedPrincipal(
          "cognito-identity.amazonaws.com",
          {
            StringEquals: {
              "cognito-identity.amazonaws.com:aud": props.identityPoolId,
            },
            "ForAnyValue:StringLike": {
              "cognito-identity.amazonaws.com:amr": "authenticated",
            },
          },
          "sts:AssumeRoleWithWebIdentity",
        ),
      },
    );
    authenticatedRole.applyRemovalPolicy(RemovalPolicy.DESTROY);
    authenticatedRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["s3:PutObject", "s3:DeleteObject"],
        resources: [
          `${userBucket.bucketArn}/profilePictures/\${cognito-identity.amazonaws.com:sub}`,
        ],
      }),
    );
    authenticatedRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["s3:GetObject"],
        resources: [`${userBucket.bucketArn}/profilePictures/*`],
      }),
    );

    const unauthenticatedRole = new Role(
      scope,
      "CognitoDefaultUnauthenticatedRole",
      {
        assumedBy: new FederatedPrincipal(
          "cognito-identity.amazonaws.com",
          {
            StringEquals: {
              "cognito-identity.amazonaws.com:aud": props.identityPoolId,
            },
            "ForAnyValue:StringLike": {
              "cognito-identity.amazonaws.com:amr": "unauthenticated",
            },
          },
          "sts:AssumeRoleWithWebIdentity",
        ),
      },
    );
    unauthenticatedRole.applyRemovalPolicy(RemovalPolicy.DESTROY);
    const defaultPolicy = new CfnIdentityPoolRoleAttachment(
      scope,
      `DefaultValid-${props.deploymentEnv}`,
      {
        identityPoolId: props.identityPoolId,
        roles: {
          unauthenticated: unauthenticatedRole.roleArn,
          authenticated: authenticatedRole.roleArn,
        },
      },
    );
    defaultPolicy.applyRemovalPolicy(RemovalPolicy.DESTROY);
  }
}
