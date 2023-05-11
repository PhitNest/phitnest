import * as fs from "fs";
import * as path from "path";

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
