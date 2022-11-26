import { inject, injectable } from "inversify";
import { IGymController } from "../adapters/controllers/interfaces";
import { IAuthMiddleware } from "../adapters/middleware/interfaces";
import { Controllers } from "../common/dependency-injection";
import { HttpMethod, IRoute, IRouter } from "./types";

@injectable()
export class GymRouter implements IRouter {
  routes: IRoute[];

  constructor(
    @inject(Controllers.gymController) gymController: IGymController,
    @inject(Controllers.authenticate) authMiddleware: IAuthMiddleware
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
