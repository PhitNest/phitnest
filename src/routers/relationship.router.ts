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
      {
        path: "/block",
        method: HttpMethod.POST,
        middlewares: [authMiddleware.authenticate],
        controller: relationshipController.block,
      },
      {
        path: "/unblock",
        method: HttpMethod.POST,
        middlewares: [authMiddleware.authenticate],
        controller: relationshipController.unblock,
      },
      {
        path: "/denyFriendRequest",
        method: HttpMethod.POST,
        middlewares: [authMiddleware.authenticate],
        controller: relationshipController.denyFriendRequest,
      },
      {
        path: "/friends",
        method: HttpMethod.GET,
        middlewares: [authMiddleware.authenticate],
        controller: relationshipController.getFriends,
      },
      {
        path: "/sentFriendRequests",
        method: HttpMethod.GET,
        middlewares: [authMiddleware.authenticate],
        controller: relationshipController.getSentFriendRequests,
      },
      {
        path: "/receivedFriendRequests",
        method: HttpMethod.GET,
        middlewares: [authMiddleware.authenticate],
        controller: relationshipController.getReceivedFriendRequests,
      },
    ];
  }
}
