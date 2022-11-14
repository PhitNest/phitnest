import express, { Router } from "express";
import controller from "./controller";
import cognito from "../../middlewares/cognito.middleware";
const router: Router = express.Router();

router.post("/register", [cognito.register], controller.register);

router.post("/login", [cognito.login], controller.login);

router.post("/refresh", [cognito.refreshSession], controller.refreshSession);

router.post(
  "/confirmRegister",
  [cognito.confirmRegister],
  controller.confirmRegister
);

router.post(
  "/forgotPassword",
  [cognito.forgotPassword],
  controller.forgotPassword
);

router.post(
  "/forgotPasswordSubmit",
  [cognito.forgotPasswordSubmit],
  controller.forgotPasswordSubmit
);

router.post(
  "/resendConfirmation",
  [cognito.resendConfirmationCode],
  controller.resendConfirmationCode
);

router.post(
  "/signOut",
  [cognito.authenticate, cognito.signOut],
  controller.signOut
);

router.get(
  "/authenticated",
  [cognito.authenticate],
  controller.isAuthenticated
);

export default router;
