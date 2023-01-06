import { inject, injectable } from "inversify";
import { IUserController } from "../adapters/controllers/interfaces";
import { IAuthMiddleware } from "../adapters/middleware/interfaces";
import { Controllers, Middlewares } from "../common/dependency-injection";
import { HttpMethod, IRoute, IRouter } from "./types";

@injectable()
export class UserRouter implements IRouter {
  routes: IRoute[];

  constructor(
    @inject(Controllers.user) userController: IUserController,
    @inject(Middlewares.authenticate) authMiddleware: IAuthMiddleware
  ) {
    this.routes = [
      {
        path: "/",
        method: HttpMethod.GET,
        middlewares: [authMiddleware],
        controller: (req, res) => userController.get(req, res),
      },
      {
        path: "/explore",
        method: HttpMethod.GET,
        middlewares: [authMiddleware],
        controller: (req, res) => userController.explore(req, res),
      },
      {
        path: "/tutorialExplore",
        method: HttpMethod.GET,
        middlewares: [],
        controller: (req, res) => userController.tutorialExplore(req, res),
      },
      {
        path: "/getProfilePictureUploadURL",
        method: HttpMethod.GET,
        middlewares: [authMiddleware],
        controller: (req, res) =>
          userController.getProfilePictureUploadUrl(req, res),
      },
    ];
  }
}
