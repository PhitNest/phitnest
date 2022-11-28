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
        controller: authController.login,
      },
      {
        path: "/register",
        method: HttpMethod.POST,
        middlewares: [],
        controller: authController.register,
      },
      {
        path: "/confirmRegister",
        method: HttpMethod.POST,
        middlewares: [],
        controller: authController.confirmRegister,
      },
      {
        path: "/refreshSession",
        method: HttpMethod.POST,
        middlewares: [],
        controller: authController.refreshSession,
      },
      {
        path: "/resendConfirmation",
        method: HttpMethod.POST,
        middlewares: [],
        controller: authController.resendConfirmation,
      },
      {
        path: "/forgotPassword",
        method: HttpMethod.POST,
        middlewares: [],
        controller: authController.forgotPassword,
      },
    ];
  }
}
