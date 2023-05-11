import { HttpMethod } from "@aws-cdk/aws-apigatewayv2";
import { getFilesRecursive } from "./helpers";
import * as path from "path";

/**
 * Type definition for a Route used for file-based routing.
 */
export type Route = {
  /**
   * The route's path as used in the API.
   */
  path: string;

  /**
   * The HTTP method used for the route.
   */
  method: HttpMethod;

  /**
   * The route's relative path in the filesystem.
   */
  filesystemRelativePath: string;

  /**
   * The route's absolute path in the filesystem.
   */
  filesystemAbsolutePath: string;
};

/**
 * Function to retrieve all routes from the filesystem.
 *
 * This function iterates through all files in the given `routeDir` and generates a `Route` object
 * for each file that matches one of the specified HTTP methods (GET, POST, PUT, PATCH, DELETE).
 * The function does not create a `Route` object for files that do not match these methods.
 *
 * @param routeDir - The directory containing the route files.
 *
 * @returns An array of `Route` objects representing all valid routes found in the `routeDir`.
 */
export function getRoutesFromFilesystem(routeDir: string): Route[] {
  return getFilesRecursive(routeDir).flatMap((file) => {
    // Initialize a variable to hold the HTTP method
    let method: HttpMethod;

    // Determine the HTTP method based on the filename
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
      // If the filename doesn't match a known HTTP method, ignore this file
      default:
        return [];
    }

    // Compute the relative and absolute paths for the route
    const relativePath = path.relative(routeDir, path.parse(file).dir);
    const absolutePath = path.join(routeDir, relativePath);

    // Format the API route path
    let apiRoutePath = relativePath.replace(path.sep, "/");
    while (apiRoutePath.endsWith("/")) {
      apiRoutePath = apiRoutePath.substring(0, apiRoutePath.length - 1);
    }
    if (!apiRoutePath.startsWith("/")) {
      apiRoutePath = `/${apiRoutePath}`;
    }

    // Return the Route object
    return {
      path: apiRoutePath,
      filesystemRelativePath: relativePath,
      filesystemAbsolutePath: absolutePath,
      method,
    };
  });
}
