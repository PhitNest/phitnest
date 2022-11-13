import express, { Router } from "express";
import controller from "./controller";
import cognito from "../../middlewares/cognito.middleware";
const router: Router = express.Router();

router.post("/sendRequest", [cognito.authenticate], controller.sendRequest);

router.post("/block", [cognito.authenticate], controller.block);

router.post("/unblock", [cognito.authenticate], controller.unblock);

router.post("/denyRequest", [cognito.authenticate], controller.denyRequest);

router.get("/friends", [cognito.authenticate], controller.myFriends);

router.get("/requests", [cognito.authenticate], controller.myRequests);

export default router;
