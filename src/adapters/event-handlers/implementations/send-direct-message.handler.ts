import { injectable, inject } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import { l } from "../../../common/logger";
import { SendDirectMessageUseCase } from "../../../use-cases/implementations";
import { IConnection } from "../../types";
import { ISendDirectMessageEventHandler } from "../interfaces";

@injectable()
export class SendDirectMessageEventHandler
  implements ISendDirectMessageEventHandler
{
  sendDirectMessageUseCase: SendDirectMessageUseCase;

  constructor(
    @inject(UseCases.sendDirectMessage)
    sendDirectMessageUseCase: SendDirectMessageUseCase
  ) {
    this.sendDirectMessageUseCase = sendDirectMessageUseCase;
  }

  async execute(connection: IConnection, data: any) {
    try {
      const { recipientId, text } = z
        .object({
          recipientId: z.string(),
          text: z.string(),
        })
        .parse(data);
      const message = await this.sendDirectMessageUseCase.execute(
        connection.locals.cognitoId,
        recipientId,
        text
      );
      connection.broadcast("directMessage", message, recipientId);
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
