import {
  AddRoutesOptions,
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

const BUILD_DIR = path.join(process.cwd(), "build");
const API_ROUTES_DIRECTORY_PATH = path.join(process.cwd(), "src", "api");
const LAMBDA_DEPLOYMENT_DIRECTORY_PATH = path.join(
  BUILD_DIR,
  "lambda_deployment"
);
const COMMON_SRC_DIR = path.join(process.cwd(), "src", "api", "common");
const COMMON_DEPLOYMENT_DIR = path.join(BUILD_DIR, "common");
const DEPLOYMENT_REGION = "us-east-1";

type PhitnestApiStackParams = {
  apiRoutesDir: string;
  lambdaDeploymentDir: string;
  commonDeploymentDir: string;
  commonSrcDir: string;
};

export class PhitnestApiStack extends Stack {
  private readonly dynamo: DynamoDBStack;
  private readonly cognito: CognitoStack;
  private readonly lambdaRole: Role;

  constructor(
    scope: Construct,
    params: PhitnestApiStackParams = {
      apiRoutesDir: API_ROUTES_DIRECTORY_PATH,
      lambdaDeploymentDir: LAMBDA_DEPLOYMENT_DIRECTORY_PATH,
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
    });
    httpApi.applyRemovalPolicy(RemovalPolicy.DESTROY);
    this.cognito = new CognitoStack(this);
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
    const privateRoutes: [string, string][] = [];
    transpileFiles(params.commonSrcDir, params.commonDeploymentDir);
    const apiNodeModulesDir = path.join(params.apiRoutesDir, "node_modules");
    for (const route of getRoutesFromFilesystem(
      path.join(params.apiRoutesDir, "private")
    )) {
      privateRoutes.push([route.path, route.method]);
      createDeploymentPackage(
        params.lambdaDeploymentDir,
        route,
        apiNodeModulesDir,
        params.commonDeploymentDir
      );
      const lambdaFunction = this.createLambdaFunction(
        params.lambdaDeploymentDir,
        route
      );
      httpApi.addRoutes(this.createHttpApiRoute(route, lambdaFunction, true));
    }
    for (const route of getRoutesFromFilesystem(
      path.join(params.apiRoutesDir, "public")
    )) {
      if (
        privateRoutes.some((r) => r[0] === route.path && r[1] === route.method)
      ) {
        throw new Error(
          `Route is defined in both public and private: ${route.method} ${route.path}`
        );
      }
      createDeploymentPackage(
        params.lambdaDeploymentDir,
        route,
        apiNodeModulesDir,
        params.commonDeploymentDir
      );
      const lambdaFunction = this.createLambdaFunction(
        params.lambdaDeploymentDir,
        route
      );
      httpApi.addRoutes(this.createHttpApiRoute(route, lambdaFunction, false));
    }
  }

  private createHttpApiRoute(
    route: Route,
    func: LambdaFunction,
    authorized: boolean
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
      authorizer: authorized
        ? this.cognito.cognitoAuthorizer
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
