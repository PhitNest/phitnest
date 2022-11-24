import { Controller } from "../../adapters/types";
import { Request } from "./request";
import { Response } from "./response";
import express from "express";

/**
 * This allows us to factory construct an express controller from our controller interface.
 */
export function buildController(controller: Controller) {
  return async function (req: express.Request, res: express.Response) {
    await controller(new Request(req), new Response(res));
  };
}
