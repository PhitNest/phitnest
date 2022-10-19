import express, { Router } from "express";
import CognitoMiddleware from "../../middlewares/cognito.middleware";
import LocationMiddleware from "../../middlewares/location.middleware";
import controller from "./controller";
const router: Router = express.Router();

router.post(
  "/",
  [CognitoMiddleware.authenticate, LocationMiddleware.locationFromAddress],
  controller.createGym
);

router.get("/list", [], controller.nearestGyms);

router.get("/nearest", [], controller.nearestGym);

export default router;
