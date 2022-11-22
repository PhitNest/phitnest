import express from "express";
import { Controllers } from "../../../dependencies";
import { buildGymRouter } from "./gym.router";

/**
 * Allows us to inject all dependencies at once and construct the full router
 */
export function buildRouter(controllers: Controllers) {
  const router = express.Router();

  router.use(
    "/gym",
    buildGymRouter(
      controllers.getGymController,
      controllers.authenticationMiddleware
    )
  );

  return router;
}
