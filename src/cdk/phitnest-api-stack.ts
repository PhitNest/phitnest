import {
  AddRoutesOptions,
  HttpApi,
  HttpNoneAuthorizer,
} from "@aws-cdk/aws-apigatewayv2";
import { Construct, Stack } from "@aws-cdk/core";
import { Code, Function as LambdaFunction, Runtime } from "@aws-cdk/aws-lambda";
import { HttpLambdaIntegration } from "@aws-cdk/aws-apigatewayv2-integrations";
import { HttpUserPoolAuthorizer } from "@aws-cdk/aws-apigatewayv2-authorizers";
import {
  AccountRecovery,
  BooleanAttribute,
  UserPool,
  UserPoolClient,
  UserPoolEmail,
} from "@aws-cdk/aws-cognito";
import {
  Route,
  createDeploymentPackage,
  getRoutesFromFilesystem,
} from "../common/file-based-routing";
import * as path from "path";

const API_ROUTES_DIRECTORY_PATH = "src/api";
const DEPLOYMENT_ENV = process.env.DEPLOYMENT_ENV || "dev";
const DEPLOYMENT_REGION = "us-east-1";

export class PhitnestApiStack extends Stack {
  private readonly httpApi: HttpApi;
  private readonly cognitoUserPool: UserPool;
  private readonly cognitoClient: UserPoolClient;
  private readonly cognitoAuthorizer: HttpUserPoolAuthorizer;

  constructor(
    scope: Construct,
    apiRoutesDir: string = API_ROUTES_DIRECTORY_PATH
  ) {
    super(scope, `PhitnestApiStack-${DEPLOYMENT_ENV}`, {
      env: {
        region: DEPLOYMENT_REGION,
      },
    });
    this.httpApi = this.createHttpApi();
    this.cognitoUserPool = this.createCognitoUserPool();
    this.cognitoClient = this.createCognitoClient();
    this.cognitoAuthorizer = this.createCognitoAuthorizer();
    this.createApiRoutes(apiRoutesDir);
  }

  private createCognitoAuthorizer(): HttpUserPoolAuthorizer {
    return new HttpUserPoolAuthorizer(
      `PhitnestCognitoAuthorizer-${DEPLOYMENT_ENV}`,
      this.cognitoUserPool,
      {
        userPoolClients: [this.cognitoClient],
        identitySource: ["$request.header.Authorization"],
      }
    );
  }

  private createCognitoUserPool(): UserPool {
    return new UserPool(this, `PhitnestUserPool-${DEPLOYMENT_ENV}`, {
      userPoolName: `Phitnest-User-Pool-${DEPLOYMENT_ENV}`,
      selfSignUpEnabled: true,
      signInAliases: {
        email: true,
        username: false,
      },
      accountRecovery: AccountRecovery.EMAIL_ONLY,
      email: UserPoolEmail.withSES({
        fromEmail: "verify@phitnest.com",
        fromName: "Phitnest Verification",
        replyTo: "verify@phitnest.com",
        sesVerifiedDomain: "phitnest.com",
      }),
      customAttributes: {
        admin: new BooleanAttribute({ mutable: true }),
      },
    });
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
        ? this.cognitoAuthorizer
        : new HttpNoneAuthorizer(),
    };
  }

  private createCognitoClient(): UserPoolClient {
    return new UserPoolClient(
      this,
      `PhitnestUserPoolClient-${DEPLOYMENT_ENV}`,
      {
        userPool: this.cognitoUserPool,
      }
    );
  }

  private createLambdaFunction(route: Route): LambdaFunction {
    return new LambdaFunction(
      this,
      `lambda-${route.path.replace("/", "-")}-${route.method}`,
      {
        runtime: Runtime.NODEJS_16_X,
        handler: `index.invoke`,
        code: Code.fromAsset(
          path.join(
            process.cwd(),
            "build",
            "lambda_deployment",
            route.filesystemRelativePath
          )
        ),
      }
    );
  }

  private createApiRoutes(apiRoutesDir: string): void {
    const privateRoutes: [string, string][] = [];
    const deploymentOutput = path.join(
      process.cwd(),
      "build",
      "lambda_deployment"
    );
    for (const route of getRoutesFromFilesystem(
      path.join(process.cwd(), apiRoutesDir, "private")
    )) {
      privateRoutes.push([route.path, route.method]);
      createDeploymentPackage(deploymentOutput, route);
      const lambdaFunction = this.createLambdaFunction(route);
      this.httpApi.addRoutes(
        this.createHttpApiRoute(route, lambdaFunction, true)
      );
    }
    for (const route of getRoutesFromFilesystem(
      path.join(process.cwd(), apiRoutesDir, "public")
    )) {
      if (
        privateRoutes.some((r) => r[0] === route.path && r[1] === route.method)
      ) {
        throw new Error(
          `Route is defined in both public and private: ${route.method} ${route.path}`
        );
      }
      createDeploymentPackage(deploymentOutput, route);
      const lambdaFunction = this.createLambdaFunction(route);
      this.httpApi.addRoutes(
        this.createHttpApiRoute(route, lambdaFunction, false)
      );
    }
  }

  private createHttpApi(): HttpApi {
    return new HttpApi(this, `PhitnestApi-${DEPLOYMENT_ENV}`, {
      description: `Phitnest API ${DEPLOYMENT_ENV}`,
      apiName: `Phitnest-API-${DEPLOYMENT_ENV}`,
    });
  }
}
