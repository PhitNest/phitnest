import { inject, injectable } from "inversify";
import { IMessageController } from "../adapters/controllers/interfaces";
import { IAuthMiddleware } from "../adapters/middleware/interfaces";
import { Controllers, Middlewares } from "../common/dependency-injection";
import { HttpMethod, IRoute } from "./types";

@injectable()
export class MessageRouter {
  routes: IRoute[];

  constructor(
    @inject(Controllers.message) messageController: IMessageController,
    @inject(Middlewares.authenticate) authMiddleware: IAuthMiddleware
  ) {
    this.routes = [
      {
        path: "/",
        method: HttpMethod.GET,
        middlewares: [authMiddleware],
        controller: (req, res) => messageController.getMessages(req, res),
      },
    ];
  }
}
