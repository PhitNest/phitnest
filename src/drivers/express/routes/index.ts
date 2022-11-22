import express from "express";
import { Controller, Middleware } from "../../../adapters/controllers";
import { buildGymRouter } from "./gym.router";

/**
 * Allows us to inject all dependencies at once and construct the full router
 */
export function buildRouter({
  authenticationMiddleware,
  getGymController,
}: {
  authenticationMiddleware: Middleware;
  getGymController: Controller;
}) {
  const router = express.Router();

  router.use(
    "/gym",
    buildGymRouter(getGymController, authenticationMiddleware)
  );

  return router;
}
