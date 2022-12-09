import { inject, injectable } from "inversify";
import { IDirectConversationController } from "../adapters/controllers/interfaces";
import { IAuthMiddleware } from "../adapters/middleware/interfaces";
import { Controllers, Middlewares } from "../common/dependency-injection";
import { HttpMethod, IRoute } from "./types";

@injectable()
export class DirectConversationRouter {
  routes: IRoute[];

  constructor(
    @inject(Middlewares.authenticate) authMiddleware: IAuthMiddleware,
    @inject(Controllers.directConversation)
    directConversationController: IDirectConversationController
  ) {
    this.routes = [
      {
        path: "/recents",
        method: HttpMethod.GET,
        middlewares: [authMiddleware],
        controller: (req, res) =>
          directConversationController.getRecentDirectConversations(req, res),
      },
    ];
  }
}
