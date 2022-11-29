import { inject, injectable } from "inversify";
import { IRelationshipController } from "../adapters/controllers/interfaces";
import { IAuthMiddleware } from "../adapters/middleware/interfaces";
import { Controllers, Middlewares } from "../common/dependency-injection";
import { HttpMethod, IRoute, IRouter } from "./types";

@injectable()
export class RelationshipRouter implements IRouter {
  routes: IRoute[];

  constructor(
    @inject(Controllers.relationship)
    relationshipController: IRelationshipController,
    @inject(Middlewares.authenticate) authMiddleware: IAuthMiddleware
  ) {
    this.routes = [
      {
        path: "/sendFriendRequest",
        method: HttpMethod.POST,
        middlewares: [authMiddleware.authenticate],
        controller: relationshipController.sendFriendRequest,
      },
    ];
  }
}
