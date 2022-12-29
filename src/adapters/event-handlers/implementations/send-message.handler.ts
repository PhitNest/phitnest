import { injectable, inject } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import { ISendMessageUseCase } from "../../../use-cases/interfaces";
import { IConnection } from "../../types";
import { ISendMessageEventHandler } from "../interfaces";

@injectable()
export class SendMessageEventHandler implements ISendMessageEventHandler {
  sendMessageUseCase: ISendMessageUseCase;

  constructor(
    @inject(UseCases.sendMessage)
    sendMessageUseCase: ISendMessageUseCase
  ) {
    this.sendMessageUseCase = sendMessageUseCase;
  }

  async execute(connection: IConnection, data: any) {
    try {
      const { conversationId, text } = z
        .object({
          conversationId: z.string(),
          text: z.string(),
        })
        .parse(data);
      const message = await this.sendMessageUseCase.execute(
        connection.locals.cognitoId,
        conversationId,
        text
      );
      connection.broadcast("message", message, conversationId);
      connection.success(message);
    } catch (err) {
      if (err instanceof z.ZodError) {
        connection.error(err.issues);
      } else if (err instanceof Error) {
        connection.error(err.message);
      } else {
        connection.error(err);
      }
    }
  }
}
