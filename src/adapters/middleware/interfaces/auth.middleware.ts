import { Middleware } from "../../types";

export interface IAuthMiddleware {
  authenticate: Middleware;
}
