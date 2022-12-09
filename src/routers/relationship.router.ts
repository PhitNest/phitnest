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
        middlewares: [authMiddleware],
        controller: (req, res) =>
          relationshipController.sendFriendRequest(req, res),
      },
      {
        path: "/block",
        method: HttpMethod.POST,
        middlewares: [authMiddleware],
        controller: (req, res) => relationshipController.block(req, res),
      },
      {
        path: "/unblock",
        method: HttpMethod.POST,
        middlewares: [authMiddleware],
        controller: (req, res) => relationshipController.unblock(req, res),
      },
      {
        path: "/denyFriendRequest",
        method: HttpMethod.POST,
        middlewares: [authMiddleware],
        controller: (req, res) =>
          relationshipController.denyFriendRequest(req, res),
      },
      {
        path: "/friends",
        method: HttpMethod.GET,
        middlewares: [authMiddleware],
        controller: (req, res) => relationshipController.getFriends(req, res),
      },
      {
        path: "/sentFriendRequests",
        method: HttpMethod.GET,
        middlewares: [authMiddleware],
        controller: (req, res) =>
          relationshipController.getSentFriendRequests(req, res),
      },
      {
        path: "/receivedFriendRequests",
        method: HttpMethod.GET,
        middlewares: [authMiddleware],
        controller: (req, res) =>
          relationshipController.getReceivedFriendRequests(req, res),
      },
    ];
  }
}
