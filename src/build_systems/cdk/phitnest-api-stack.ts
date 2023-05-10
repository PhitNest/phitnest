import {
  AddRoutesOptions,
  HttpApi,
  HttpNoneAuthorizer,
  IHttpRouteAuthorizer,
} from "@aws-cdk/aws-apigatewayv2";
import { Construct, RemovalPolicy, Stack } from "@aws-cdk/core";
import { Code, Function as LambdaFunction, Runtime } from "@aws-cdk/aws-lambda";
import { HttpLambdaIntegration } from "@aws-cdk/aws-apigatewayv2-integrations";
import { Route, getRoutesFromFilesystem } from "../common/file-based-routing";
import { createDeploymentPackage } from "./lambda-deployment";
import { CognitoStack } from "./cognito-stack";
import { DynamoDBStack } from "./dynamodb-stack";
import * as path from "path";

export const DEPLOYMENT_ENV = process.env.DEPLOYMENT_ENV || "dev";

const API_ROUTES_DIRECTORY_PATH = path.join(process.cwd(), "src", "api");
const LAMBDA_DEPLOYMENT_DIRECTORY_PATH = path.join(
  process.cwd(),
  "build",
  "lambda_deployment"
);
const DEPLOYMENT_REGION = "us-east-1";

function createHttpApiRoute(
  route: Route,
  func: LambdaFunction,
  authorizer?: IHttpRouteAuthorizer
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
    authorizer: authorizer ?? new HttpNoneAuthorizer(),
  };
}

export class PhitnestApiStack extends Stack {
  constructor(
    scope: Construct,
    apiRoutesDir: string = API_ROUTES_DIRECTORY_PATH,
    lambdaDeploymentDir: string = LAMBDA_DEPLOYMENT_DIRECTORY_PATH
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
    const cognito = new CognitoStack(this);
    const dynamo = new DynamoDBStack(this);
    const privateRoutes: [string, string][] = [];
    const apiNodeModulesDir = path.join(apiRoutesDir, "node_modules");
    for (const route of getRoutesFromFilesystem(
      path.join(apiRoutesDir, "private")
    )) {
      privateRoutes.push([route.path, route.method]);
      createDeploymentPackage(lambdaDeploymentDir, route, apiNodeModulesDir);
      const lambdaFunction = this.createLambdaFunction(
        lambdaDeploymentDir,
        route,
        {
          DYNAMO_TABLE_CONN_STRING: dynamo.table.tableName || "",
          AWS_REGION: DEPLOYMENT_REGION,
        }
      );
      httpApi.addRoutes(
        createHttpApiRoute(route, lambdaFunction, cognito.cognitoAuthorizer)
      );
    }
    for (const route of getRoutesFromFilesystem(
      path.join(apiRoutesDir, "public")
    )) {
      if (
        privateRoutes.some((r) => r[0] === route.path && r[1] === route.method)
      ) {
        throw new Error(
          `Route is defined in both public and private: ${route.method} ${route.path}`
        );
      }
      createDeploymentPackage(lambdaDeploymentDir, route, apiNodeModulesDir);
      const lambdaFunction = this.createLambdaFunction(
        lambdaDeploymentDir,
        route
      );
      httpApi.addRoutes(createHttpApiRoute(route, lambdaFunction));
    }
  }

  private createLambdaFunction(
    lambdaDeploymentPath: string,
    route: Route,
    environmentVars: { [key: string]: string } = {}
  ): LambdaFunction {
    const func = new LambdaFunction(
      this,
      `lambda-${route.path.replace("/", "-")}-${route.method}`,
      {
        runtime: Runtime.NODEJS_16_X,
        handler: `index.invoke`,
        environment: environmentVars,
        code: Code.fromAsset(
          path.join(
            lambdaDeploymentPath,
            route.filesystemRelativePath,
            route.method.toLowerCase()
          )
        ),
      }
    );
    func.applyRemovalPolicy(RemovalPolicy.DESTROY);
    return func;
  }
}
