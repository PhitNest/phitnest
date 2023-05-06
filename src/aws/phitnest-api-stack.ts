import { Stack } from "aws-cdk-lib";
import { HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import { Construct } from "constructs";
import { getFilesRecursive } from "../common/helpers";
import * as path from "path";

const API_ROUTES_DIRECTORY_PATH = "src/api/routes";

export type Route = {
  path: string;
  method: HttpMethod;
};

export function getRoutes(routeDir: string): Route[] {
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
    routes.push({
      path: path
        .relative(routeDir, path.parse(file).dir)
        .replace(path.sep, "/"),
      method,
    });
  }
  return routes;
}

export class PhitnestApiStack extends Stack {
  constructor(scope: Construct) {
    super(scope, "PhitnestApiStack");

    const routes = getRoutes(API_ROUTES_DIRECTORY_PATH);
  }
}
