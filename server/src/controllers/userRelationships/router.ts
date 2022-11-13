import express, { Router } from "express";
import controller from "./controller";
import cognito from "../../middlewares/cognito.middleware";
import userRelationship from "../../middlewares/userRelationship.middleware";
const router: Router = express.Router();

router.post(
  "/sendRequest",
  [cognito.authenticate, userRelationship.validate],
  controller.sendRequest
);

router.post(
  "/block",
  [cognito.authenticate, userRelationship.validate],
  controller.block
);

router.post(
  "/unblock",
  [cognito.authenticate, userRelationship.validate],
  controller.unblock
);

router.post(
  "/denyRequest",
  [cognito.authenticate, userRelationship.validate],
  controller.denyRequest
);

router.get("/friends", [cognito.authenticate], controller.myFriends);

router.get("/sentRequests", [cognito.authenticate], controller.mySentRequests);

router.get(
  "/receivedRequests",
  [cognito.authenticate],
  controller.myReceivedRequests
);

export default router;
