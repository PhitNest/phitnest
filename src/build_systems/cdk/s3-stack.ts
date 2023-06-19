import { Bucket, HttpMethods } from "@aws-cdk/aws-s3";
import { DEPLOYMENT_ENV, PhitnestApiStack } from "./phitnest-api-stack";
import { RemovalPolicy } from "@aws-cdk/core";
import {
  Effect,
  FederatedPrincipal,
  PolicyStatement,
  Role,
} from "@aws-cdk/aws-iam";
import {
  CfnIdentityPool,
  CfnIdentityPoolRoleAttachment,
} from "@aws-cdk/aws-cognito";

interface S3StackParams {
  identityPool: CfnIdentityPool;
}

export class S3Stack {
  public readonly userBucket: Bucket;

  constructor(scope: PhitnestApiStack, params: S3StackParams) {
    this.userBucket = new Bucket(scope, "PhitnestBucket", {
      bucketName: `phitnest-user-bucket-${DEPLOYMENT_ENV}`,
      autoDeleteObjects: true,
      removalPolicy: RemovalPolicy.DESTROY,
      cors: [
        {
          allowedHeaders: ["*"],
          allowedMethods: [HttpMethods.POST, HttpMethods.PUT, HttpMethods.GET],
          allowedOrigins: ["*"],
          exposedHeaders: [
            "x-amz-server-side-encryption",
            "x-amz-request-id",
            "x-amz-id-2",
            "ETag",
          ],
        },
      ],
    });

    const authenticatedRole = new Role(
      scope,
      `CognitoDefaultAuthenticatedRole-${DEPLOYMENT_ENV}`,
      {
        assumedBy: new FederatedPrincipal(
          "cognito-identity.amazonaws.com",
          {
            StringEquals: {
              "cognito-identity.amazonaws.com:aud": params.identityPool.ref,
            },
            "ForAnyValue:StringLike": {
              "cognito-identity.amazonaws.com:amr": "authenticated",
            },
          },
          "sts:AssumeRoleWithWebIdentity"
        ),
      }
    );
    authenticatedRole.applyRemovalPolicy(RemovalPolicy.DESTROY);
    authenticatedRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.ALLOW,
        actions: ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        resources: [
          `${this.userBucket.bucketArn}/private/\${cognito-identity.amazonaws.com:sub}/*`,
        ],
      })
    );

    // Role for UNauthenticated Users
    const unauthenticatedRole = new Role(
      scope,
      "CognitoDefaultUnauthenticatedRole",
      {
        assumedBy: new FederatedPrincipal(
          "cognito-identity.amazonaws.com",
          {
            StringEquals: {
              "cognito-identity.amazonaws.com:aud": params.identityPool.ref,
            },
            "ForAnyValue:StringLike": {
              "cognito-identity.amazonaws.com:amr": "unauthenticated",
            },
          },
          "sts:AssumeRoleWithWebIdentity"
        ),
      }
    );
    unauthenticatedRole.applyRemovalPolicy(RemovalPolicy.DESTROY);
    unauthenticatedRole.addToPolicy(
      new PolicyStatement({
        effect: Effect.DENY,
        actions: ["s3:*", "cognito-identity:*"],
        resources: ["*"],
      })
    );

    const defaultPolicy = new CfnIdentityPoolRoleAttachment(
      scope,
      "DefaultValid",
      {
        identityPoolId: params.identityPool.ref,
        roles: {
          unauthenticated: unauthenticatedRole.roleArn,
          authenticated: authenticatedRole.roleArn,
        },
      }
    );
    defaultPolicy.applyRemovalPolicy(RemovalPolicy.DESTROY);
  }
}
