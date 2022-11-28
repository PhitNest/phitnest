import { inject, injectable } from "inversify";
import { IGymController } from "../adapters/controllers/interfaces";
import { IAuthMiddleware } from "../adapters/middleware/interfaces";
import { Controllers, Middlewares } from "../common/dependency-injection";
import { HttpMethod, IRoute, IRouter } from "./types";

@injectable()
export class GymRouter implements IRouter {
  routes: IRoute[];

  constructor(
    @inject(Controllers.gym) gymController: IGymController,
    @inject(Middlewares.authenticate) authMiddleware: IAuthMiddleware
  ) {
    this.routes = [
      {
        path: "/",
        method: HttpMethod.GET,
        middlewares: [authMiddleware.authenticate],
        controller: gymController.get,
      },
      {
        path: "/",
        method: HttpMethod.POST,
        // TODO: SECURE WITH ADMIN AUTH
        middlewares: [authMiddleware.authenticate],
        controller: gymController.create,
      },
      {
        path: "/nearest",
        method: HttpMethod.GET,
        middlewares: [],
        controller: gymController.getNearest,
      },
    ];
  }
}
