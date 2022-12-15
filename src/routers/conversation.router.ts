import { inject, injectable } from "inversify";
import { IConversationController } from "../adapters/controllers/interfaces";
import { IAuthMiddleware } from "../adapters/middleware/interfaces";
import { Controllers, Middlewares } from "../common/dependency-injection";
import { HttpMethod, IRoute } from "./types";

@injectable()
export class ConversationRouter {
  routes: IRoute[];

  constructor(
    @inject(Middlewares.authenticate) authMiddleware: IAuthMiddleware,
    @inject(Controllers.conversation)
    conversationController: IConversationController
  ) {
    this.routes = [
      {
        path: "/recents",
        method: HttpMethod.GET,
        middlewares: [authMiddleware],
        controller: (req, res) =>
          conversationController.getRecentConversations(req, res),
      },
    ];
  }
}
