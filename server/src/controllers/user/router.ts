import express, { Router } from "express";
import CognitoMiddleware from "../../middlewares/cognito.middleware";
import controller from "./controller";
const router: Router = express.Router();

router.get("/", [CognitoMiddleware.authenticate], controller.myData);

router.get("/explore", [CognitoMiddleware.authenticate], controller.explore);

export default router;
