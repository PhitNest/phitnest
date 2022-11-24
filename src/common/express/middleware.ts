import { Middleware } from "../../adapters/types";
import { Request } from "./request";
import { Response } from "./response";
import express from "express";

/**
 * This allows us to factory construct an array of middlewares from an array of middleware interfaces.
 */
export function buildMiddleware(middlewares: Middleware[]) {
  return middlewares.map(
    (middleware) =>
      async function (
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
      ) {
        await middleware(new Request(req), new Response(res), next);
      }
  );
}
