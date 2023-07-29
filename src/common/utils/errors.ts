import { RequestError } from "./request-handling";

export const kUserNotFound = new RequestError(
  "UserNotFound",
  "You are registered with our identity pool but you do not have an account in the database."
);
