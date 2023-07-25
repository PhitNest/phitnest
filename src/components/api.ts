import { RemovalPolicy } from "aws-cdk-lib";
import {
  AuthorizationType,
  CognitoUserPoolsAuthorizer,
  Cors,
  LambdaIntegration,
  RestApi,
} from "aws-cdk-lib/aws-apigateway";
import { Code, Function, Runtime } from "aws-cdk-lib/aws-lambda";
import { UserPool } from "aws-cdk-lib/aws-cognito";
import { NodejsFunction } from "aws-cdk-lib/aws-lambda-nodejs";
import { Role } from "aws-cdk-lib/aws-iam";
import { Certificate, ICertificate } from "aws-cdk-lib/aws-certificatemanager";
import { Construct } from "constructs";
import {
  Route,
  getRoutesFromFilesystem,
  createDeploymentPackage,
} from "../utils";
import * as path from "path";

enum AuthLevel {
  PUBLIC = "public",
  PRIVATE = "private",
  ADMIN = "admin",
}

export interface ApiStackProps {
  deploymentEnv: string;
  apiSrcDir: string;
  nodeModulesDir: string;
  commonDir: string;
  apiDeploymentDir: string;
  dynamoTableRole: Role;
  dynamoTableName: string;
  userPool: UserPool;
  adminPool: UserPool;
  userClientId: string;
  adminClientId: string;
  userIdentityPoolId: string;
  userBucketName: string;
  region: string;
  apiRoute53CertificateArn: string | undefined;
}

export class ApiStack extends Construct {
  private readonly props: ApiStackProps;

  constructor(scope: Construct, props: ApiStackProps) {
    super(scope, `phitnest-api-stack-${props.deploymentEnv}`);
    this.props = props;

    const userAuthorizer = new CognitoUserPoolsAuthorizer(
      scope,
      `PhitNestUserAuthorizer-${this.props.deploymentEnv}`,
      {
        cognitoUserPools: [props.userPool],
      }
    );
    userAuthorizer.applyRemovalPolicy(RemovalPolicy.DESTROY);

    const adminAuthorizer = new CognitoUserPoolsAuthorizer(
      scope,
      `PhitNestAdminAuthorizer-${this.props.deploymentEnv}`,
      {
        cognitoUserPools: [props.adminPool],
      }
    );
    adminAuthorizer.applyRemovalPolicy(RemovalPolicy.DESTROY);
    let route53Certificate: ICertificate | undefined;
    if (props.apiRoute53CertificateArn) {
      route53Certificate = Certificate.fromCertificateArn(
        scope,
        `phitnest-route53-certificate-${props.deploymentEnv}`,
        props.apiRoute53CertificateArn
      );
      route53Certificate.applyRemovalPolicy(RemovalPolicy.DESTROY);
    }
    const api = new RestApi(scope, `phitnest-rest-api-${props.deploymentEnv}`, {
      restApiName: `Phitnest-API-${props.deploymentEnv}`,
      description: "This service serves the Phitnest API.",
      domainName: route53Certificate
        ? {
            domainName: "api.phitnest.com",
            certificate: route53Certificate,
          }
        : undefined,
      defaultCorsPreflightOptions: {
        allowHeaders: Cors.DEFAULT_HEADERS,
        allowOrigins: Cors.ALL_ORIGINS,
        allowMethods: Cors.ALL_METHODS,
        allowCredentials: true,
      },
    });
    api.applyRemovalPolicy(RemovalPolicy.DESTROY);

    const routes: Route[] = [];
    for (const authLevel of Object.entries(AuthLevel)) {
      for (const route of getRoutesFromFilesystem(
        path.join(props.apiSrcDir, authLevel[1])
      )) {
        if (routes.includes(route)) {
          throw new Error(
            `Route is defined twice: ${route.method} ${route.path}`
          );
        }
        routes.push(route);

        createDeploymentPackage(
          path.join(
            route.filesystemAbsolutePath,
            `${route.method.toLowerCase()}.ts`
          ),
          props.nodeModulesDir,
          props.commonDir,
          this.deploymentDir(route)
        );

        const lambdaFunction = this.createLambdaFunction(scope, route);
        const resource = api.root.resourceForPath(route.path);
        resource.addMethod(
          route.method,
          new LambdaIntegration(lambdaFunction),
          {
            authorizationType:
              authLevel[1] === AuthLevel.PUBLIC
                ? undefined
                : AuthorizationType.COGNITO,
            authorizer:
              authLevel[1] === AuthLevel.PRIVATE
                ? userAuthorizer
                : authLevel[1] === AuthLevel.ADMIN
                ? adminAuthorizer
                : undefined,
          }
        );
      }
    }
  }

  private deploymentDir(route: Route): string {
    return path.join(
      this.props.apiDeploymentDir,
      route.filesystemRelativePath,
      route.method.toLowerCase()
    );
  }

  private createLambdaFunction(scope: Construct, route: Route): NodejsFunction {
    const deploymentDir = this.deploymentDir(route);
    const func = new Function(
      scope,
      `lambda-${route.path.replace("/", "-")}-${route.method}-${
        this.props.deploymentEnv
      }`,
      {
        runtime: Runtime.NODEJS_16_X,
        handler: "index.invoke",
        code: Code.fromAsset(deploymentDir),
        environment: {
          DYNAMO_TABLE_NAME: this.props.dynamoTableName,
          USER_POOL_ID: this.props.userPool.userPoolId,
          ADMIN_POOL_ID: this.props.adminPool.userPoolId,
          USER_POOL_CLIENT_ID: this.props.userClientId,
          ADMIN_POOL_CLIENT_ID: this.props.adminClientId,
          USER_IDENTITY_POOL_ID: this.props.userIdentityPoolId,
          USER_S3_BUCKET_NAME: this.props.userBucketName,
          REGION: this.props.region,
        },
        role: this.props.dynamoTableRole,
      }
    );
    func.applyRemovalPolicy(RemovalPolicy.DESTROY);
    return func;
  }
}
