import express from "express";
import { Controller, Middleware } from "../../../adapters/controllers";
import { buildController } from "../buildController";
import { buildMiddleware } from "../buildMiddleware";

export function buildGymRouter(
  getGymController: Controller,
  getNearestGymsController: Controller,
  authenticationMiddleware: Middleware
) {
  const router = express.Router();

  router.get(
    "/",
    buildMiddleware([authenticationMiddleware]),
    buildController(getGymController)
  );

  router.get("/nearest", buildController(getNearestGymsController));

  return router;
}
