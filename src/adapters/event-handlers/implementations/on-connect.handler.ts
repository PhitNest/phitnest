import { inject, injectable } from "inversify";
import { UseCases } from "../../../common/dependency-injection";
import { l } from "../../../common/logger";
import { IGetConversationsUseCase } from "../../../use-cases/interfaces";
import { IConnection } from "../../types";
import { IOnConnectEventHandler } from "../interfaces";

@injectable()
export class OnConnectEventHandler implements IOnConnectEventHandler {
  getConversationsUseCase: IGetConversationsUseCase;

  constructor(
    @inject(UseCases.getConversations)
    getConversationsUseCase: IGetConversationsUseCase
  ) {
    this.getConversationsUseCase = getConversationsUseCase;
  }

  async execute(connection: IConnection) {
    connection.joinRoom(connection.locals.cognitoId);
    const conversations = await this.getConversationsUseCase.execute(
      connection.locals.cognitoId
    );
    for (let i = 0; i < conversations.length; i++) {
      connection.joinRoom(conversations[i]._id);
    }
    l.info(`User ${connection.locals.cognitoId} connected`);
  }
}
