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
        path: "/gym",
        method: HttpMethod.GET,
        middlewares: [authMiddleware.authenticate],
        controller: gymController.get,
      },

      {
        path: "/gym/nearest",
        method: HttpMethod.GET,
        middlewares: [],
        controller: gymController.getNearest,
      },
    ];
  }
}
