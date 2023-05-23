import {
  AddRoutesOptions,
  CorsHttpMethod,
  HttpApi,
  HttpNoneAuthorizer,
} from "@aws-cdk/aws-apigatewayv2";
import { Construct, RemovalPolicy, Stack } from "@aws-cdk/core";
import { Code, Function as LambdaFunction, Runtime } from "@aws-cdk/aws-lambda";
import { HttpLambdaIntegration } from "@aws-cdk/aws-apigatewayv2-integrations";
import {
  Effect,
  PolicyDocument,
  PolicyStatement,
  Role,
  ServicePrincipal,
} from "@aws-cdk/aws-iam";
import { Route, getRoutesFromFilesystem } from "../utils/file-based-routing";
import { createDeploymentPackage, transpileFiles } from "./lambda-deployment";
import { CognitoStack } from "./cognito-stack";
import { DynamoDBStack } from "./dynamodb-stack";
import * as path from "path";

export const DEPLOYMENT_ENV = process.env.DEPLOYMENT_ENV || "dev";

export const BUILD_DIR = path.join(process.cwd(), "build");
export const API_DIR = path.join(process.cwd(), "src", "api");
export const LAMBDA_DEPLOYMENT_DIR = path.join(BUILD_DIR, "lambda_deployment");
export const COMMON_SRC_DIR = path.join(process.cwd(), "src", "api", "common");
export const COMMON_DEPLOYMENT_DIR = path.join(BUILD_DIR, "common");
export const DEPLOYMENT_REGION = "us-east-1";

enum AuthLevel {
  PUBLIC = "public",
  PRIVATE = "private",
  ADMIN = "admin",
}

type PhitnestApiStackParams = {
  apiRoutesDir: string;
  lambdaDeploymentDir: string;
  commonDeploymentDir: string;
  commonSrcDir: string;
};

export class PhitnestApiStack extends Stack {
  public readonly dynamo: DynamoDBStack;
  public readonly lambdaRole: Role;
  private readonly cognito: CognitoStack;

  constructor(
    scope: Construct,
    params: PhitnestApiStackParams = {
      apiRoutesDir: API_DIR,
      lambdaDeploymentDir: LAMBDA_DEPLOYMENT_DIR,
      commonDeploymentDir: COMMON_DEPLOYMENT_DIR,
      commonSrcDir: COMMON_SRC_DIR,
    }
  ) {
    super(scope, `PhitnestApiStack-${DEPLOYMENT_ENV}`, {
      env: {
        region: DEPLOYMENT_REGION,
      },
    });
    const httpApi = new HttpApi(this, `PhitnestApi-${DEPLOYMENT_ENV}`, {
      description: `Phitnest API ${DEPLOYMENT_ENV}`,
      apiName: `Phitnest-API-${DEPLOYMENT_ENV}`,
      corsPreflight: {
        allowHeaders: [
          "Content-Type",
          "X-Amz-Date",
          "Authorization",
          "X-Api-Key",
          "X-Amz-Security-Token",
        ],
        allowOrigins: ["*"],
        allowCredentials: true,
        allowMethods: [
          CorsHttpMethod.GET,
          CorsHttpMethod.POST,
          CorsHttpMethod.PUT,
          CorsHttpMethod.DELETE,
        ],
      },
    });
    httpApi.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.dynamo = new DynamoDBStack(this);
    this.lambdaRole = new Role(this, `PhitnestLambdaRole-${DEPLOYMENT_ENV}`, {
      assumedBy: new ServicePrincipal("lambda.amazonaws.com"),
      inlinePolicies: {
        dynamoAccess: new PolicyDocument({
          statements: [
            new PolicyStatement({
              sid: "AllowDynamoAccessForApi",
              effect: Effect.ALLOW,
              actions: ["dynamodb:*"],
              resources: [this.dynamo.table.attrArn],
            }),
          ],
        }),
      },
    });
    transpileFiles(params.commonSrcDir, params.commonDeploymentDir);
    const apiNodeModulesDir = path.join(params.apiRoutesDir, "node_modules");
    this.cognito = new CognitoStack(this, {
      cognitoHooksDir: path.join(params.apiRoutesDir, "cognito_hooks"),
      nodeModulesDir: apiNodeModulesDir,
      ...params,
    });
    const routes: Route[] = [];
    for (const authLevel of Object.entries(AuthLevel)) {
      for (const route of getRoutesFromFilesystem(
        path.join(params.apiRoutesDir, authLevel[1])
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
          path.join(
            params.lambdaDeploymentDir,
            route.filesystemRelativePath,
            route.method.toLowerCase()
          ),
          apiNodeModulesDir,
          params.commonDeploymentDir
        );
        const lambdaFunction = this.createLambdaFunction(
          params.lambdaDeploymentDir,
          route
        );
        httpApi.addRoutes(
          this.createHttpApiRoute(route, lambdaFunction, authLevel[1])
        );
      }
    }
  }

  private createHttpApiRoute(
    route: Route,
    func: LambdaFunction,
    authLevel: AuthLevel
  ): AddRoutesOptions {
    return {
      path: route.path,
      methods: [route.method],
      integration: new HttpLambdaIntegration(
        `integration-${route.path.replace("/", "-")}-${
          route.method
        }-${DEPLOYMENT_ENV}`,
        func
      ),
      authorizer:
        authLevel === AuthLevel.PRIVATE
          ? this.cognito.userAuthorizer
          : authLevel === AuthLevel.ADMIN
          ? this.cognito.adminAuthorizer
          : new HttpNoneAuthorizer(),
    };
  }

  private createLambdaFunction(
    lambdaDeploymentPath: string,
    route: Route
  ): LambdaFunction {
    const func = new LambdaFunction(
      this,
      `lambda-${route.path.replace("/", "-")}-${
        route.method
      }-${DEPLOYMENT_ENV}`,
      {
        runtime: Runtime.NODEJS_16_X,
        handler: `index.invoke`,
        environment: {
          DYNAMO_TABLE_NAME:
            this.dynamo.table.tableName || `PhitnestTable-${DEPLOYMENT_ENV}`,
          USER_POOL_ID: this.cognito.userPool.userPoolId,
          ADMIN_POOL_ID: this.cognito.adminPool.userPoolId,
          USER_POOL_CLIENT_ID: this.cognito.userClient.userPoolClientId,
          ADMIN_POOL_CLIENT_ID: this.cognito.adminClient.userPoolClientId,
        },
        code: Code.fromAsset(
          path.join(
            lambdaDeploymentPath,
            route.filesystemRelativePath,
            route.method.toLowerCase()
          )
        ),
        role: this.lambdaRole,
      }
    );
    func.applyRemovalPolicy(RemovalPolicy.DESTROY);
    return func;
  }
}
