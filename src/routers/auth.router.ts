import { inject, injectable } from "inversify";
import { IAuthController } from "../adapters/controllers/interfaces";
import { IAuthMiddleware } from "../adapters/middleware/interfaces";
import { Controllers, Middlewares } from "../common/dependency-injection";
import { HttpMethod, IRoute, IRouter } from "./types";

@injectable()
export class AuthRouter implements IRouter {
  routes: IRoute[];

  constructor(
    @inject(Controllers.auth) authController: IAuthController,
    @inject(Middlewares.authenticate) authMiddleware: IAuthMiddleware
  ) {
    this.routes = [
      {
        path: "/login",
        method: HttpMethod.POST,
        middlewares: [],
        controller: (req, res) => authController.login(req, res),
      },
      {
        path: "/register",
        method: HttpMethod.POST,
        middlewares: [],
        controller: (req, res) => authController.register(req, res),
      },
      {
        path: "/confirmRegister",
        method: HttpMethod.POST,
        middlewares: [],
        controller: (req, res) => authController.confirmRegister(req, res),
      },
      {
        path: "/refreshSession",
        method: HttpMethod.POST,
        middlewares: [],
        controller: (req, res) => authController.refreshSession(req, res),
      },
      {
        path: "/resendConfirmation",
        method: HttpMethod.POST,
        middlewares: [],
        controller: (req, res) => authController.resendConfirmation(req, res),
      },
      {
        path: "/forgotPassword",
        method: HttpMethod.POST,
        middlewares: [],
        controller: (req, res) => authController.forgotPassword(req, res),
      },
      {
        path: "/forgotPasswordSubmit",
        method: HttpMethod.POST,
        middlewares: [],
        controller: (req, res) => authController.forgotPasswordSubmit(req, res),
      },
      {
        path: "/signOut",
        method: HttpMethod.POST,
        middlewares: [authMiddleware],
        controller: (req, res) => authController.signOut(req, res),
      },
      {
        path: "/getUploadProfilePictureURL",
        method: HttpMethod.GET,
        middlewares: [],
        controller: (req, res) =>
          authController.getUploadProfilePictureUrlUnconfirmed(req, res),
      },
    ];
  }
}
