import { HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import { getFilesRecursive } from "./helpers";
import * as path from "path";

export type Route = {
  path: string;
  method: HttpMethod;
  filesystemRelativePath: string;
  filesystemAbsolutePath: string;
};

export function getRoutesFromFilesystem(routeDir: string): Route[] {
  return getFilesRecursive(routeDir).flatMap((file) => {
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
        return [];
    }
    const relativePath = path.relative(routeDir, path.parse(file).dir);
    const absolutePath = path.join(routeDir, relativePath);
    let apiRoutePath = relativePath.replace(path.sep, "/");
    while (apiRoutePath.endsWith("/")) {
      apiRoutePath = apiRoutePath.substring(0, apiRoutePath.length - 1);
    }
    if (!apiRoutePath.startsWith("/")) {
      apiRoutePath = `/${apiRoutePath}`;
    }
    return {
      path: apiRoutePath,
      filesystemRelativePath: relativePath,
      filesystemAbsolutePath: absolutePath,
      method,
    };
  });
}
