import { Failure } from "../failure";

export const kUserNotFound = new Failure(
  "UserNotFoundException",
  "User not found"
);
