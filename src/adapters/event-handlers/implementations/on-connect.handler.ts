import { inject, injectable } from "inversify";
import { UseCases } from "../../../common/dependency-injection";
import { l } from "../../../common/logger";
import { IGetDirectConversationsUseCase } from "../../../use-cases/interfaces";
import { IConnection } from "../../types";
import { IOnConnectEventHandler } from "../interfaces";

@injectable()
export class OnConnectEventHandler implements IOnConnectEventHandler {
  getDirectConversationsUseCase: IGetDirectConversationsUseCase;

  constructor(
    @inject(UseCases.getDirectConversations)
    getDirectConversationsUseCase: IGetDirectConversationsUseCase
  ) {
    this.getDirectConversationsUseCase = getDirectConversationsUseCase;
  }

  async execute(connection: IConnection) {
    try {
      const conversations = await this.getDirectConversationsUseCase.execute(
        connection.locals.cognitoId
      );
      conversations.forEach((conversation) => {
        connection.joinRoom(conversation._id);
      });
    } catch (err) {
      if (err instanceof Error) {
        connection.send("Error", err.message);
      } else {
        connection.send("Error", err);
      }
    }
  }
}
