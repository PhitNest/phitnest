import { inject, injectable } from "inversify";
import { IUserController } from "../adapters/controllers/interfaces";
import { IAuthMiddleware } from "../adapters/middleware/interfaces";
import { Controllers } from "../common/dependency-injection";
import { HttpMethod, IRoute, IRouter } from "./types";

@injectable()
export class UserRouter implements IRouter {
  routes: IRoute[];

  constructor(
    @inject(Controllers.user) userController: IUserController,
    @inject(Controllers.authenticate) authMiddleware: IAuthMiddleware
  ) {
    this.routes = [
      {
        path: "/",
        method: HttpMethod.GET,
        middlewares: [authMiddleware.authenticate],
        controller: userController.get,
      },
      {
        path: "/explore",
        method: HttpMethod.GET,
        middlewares: [authMiddleware.authenticate],
        controller: userController.explore,
      },
    ];
  }
}
