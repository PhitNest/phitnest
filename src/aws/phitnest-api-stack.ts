import { HttpApi, HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import { Construct, Stack, StackProps } from "@aws-cdk/core";
import { Code, Function as LambdaFunction, Runtime } from "@aws-cdk/aws-lambda";
import { HttpLambdaIntegration } from "@aws-cdk/aws-apigatewayv2-integrations";
import { getFilesRecursive, getProjectRoot } from "../common/helpers";
import * as path from "path";

const API_ROUTES_DIRECTORY_PATH = "src/api/routes";

export type Route = {
  path: string;
  method: HttpMethod;
  filesystemPath: string;
};

export function getRoutesFromFilesystem(routeDir: string): Route[] {
  const files = getFilesRecursive(routeDir);
  const routes: Route[] = [];
  for (const file of files) {
    let method: HttpMethod;
    switch (path.parse(file).name) {
      case "get":
        method = HttpMethod.GET;
        break;
      case "post":
        method = HttpMethod.POST;
        break;
      case "put":
        method = HttpMethod.PUT;
        break;
      case "patch":
        method = HttpMethod.PATCH;
        break;
      case "delete":
        method = HttpMethod.DELETE;
        break;
      default:
        continue;
    }
    const relativePath = path.relative(routeDir, path.parse(file).dir);
    routes.push({
      path: relativePath.replace(path.sep, "/"),
      filesystemPath: path.join(routeDir, relativePath),
      method,
    });
  }
  return routes;
}

export class PhitnestApiStack extends Stack {
  constructor(
    scope: Construct,
    props?: StackProps,
    apiRoutesDir: string = API_ROUTES_DIRECTORY_PATH
  ) {
    super(scope, "PhitnestApiStack", props);
    const httpApi = new HttpApi(this, "PhitnestApi", {
      description: "Phitnest API",
    });
    for (const route of getRoutesFromFilesystem(
      path.join(getProjectRoot(), apiRoutesDir)
    )) {
      const id = `${route.path.replace("/", "-")}-${route.method}`;
      const lambdaFunction = new LambdaFunction(this, id, {
        runtime: Runtime.NODEJS_16_X,
        handler: `${route.method.toLowerCase()}.invoke`,
        code: Code.fromAsset(route.filesystemPath),
      });
      httpApi.addRoutes({
        path: route.path,
        methods: [route.method],
        integration: new HttpLambdaIntegration(
          `integration-${id}`,
          lambdaFunction
        ),
      });
    }
  }
}
