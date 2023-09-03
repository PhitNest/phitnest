import { HttpMethod } from "aws-cdk-lib/aws-lambda";
import * as path from "path";
import * as fs from "fs";

/**
 * Recursively retrieves all file paths within the specified directory.
 *
 * This function uses the Node.js filesystem (fs) and path modules to read directories and construct file paths.
 * It starts from the directory specified by `dirName`, and if it encounters a subdirectory, it makes a recursive
 * call to explore that subdirectory. If it encounters a file, it includes the file's path in the output array.
 *
 * Note that this function synchronously reads the directory contents, which may not be suitable for very large
 * directories or for use in performance-sensitive contexts. Also, it does not handle possible exceptions that might
 * be thrown upon trying to read inaccessible directories or files.
 *
 * @param dirName - The path to the directory from which to start retrieving file paths.
 *
 * @returns An array of strings where each string is the path to a file within the directory specified by `dirName`.
 *          The paths to files are absolute if `dirName` is absolute, and relative to `dirName` if `dirName` is relative.
 */
export function getFilesRecursive(dirName: string): string[] {
  // Read the directory contents
  return fs.readdirSync(dirName, { withFileTypes: true }).flatMap((item) => {
    // Construct the path to the item
    const filePath = path.join(dirName, item.name);
    // Check if the item is a directory
    if (item.isDirectory()) {
      // If it's a directory, recursively retrieve the files within it
      return getFilesRecursive(filePath);
    } else {
      // If it's a file, include its path in the output array
      return filePath;
    }
  });
}

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
   * The route's relative path in the filesystem. (relative to the routeDir)
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

    const filePath = path.parse(file);
    if (filePath.name !== "index") {
      return [];
    }

    // Determine the HTTP method based on the dirname of the file
    switch (filePath.dir) {
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
    const relativePath = path.relative(routeDir, path.parse(path.parse(file).dir).dir);
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
      filesystemRelativePath: path.join(relativePath, filePath.dir),
      filesystemAbsolutePath: path.join(absolutePath, filePath.dir),
      method,
    };
  });
}
