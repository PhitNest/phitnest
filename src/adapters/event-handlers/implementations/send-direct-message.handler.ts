import { injectable, inject } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import { ISendDirectMessageUseCase } from "../../../use-cases/interfaces";
import { IConnection } from "../../types";
import { ISendDirectMessageEventHandler } from "../interfaces";

@injectable()
export class SendDirectMessageEventHandler
  implements ISendDirectMessageEventHandler
{
  sendDirectMessageUseCase: ISendDirectMessageUseCase;

  constructor(
    @inject(UseCases.sendDirectMessage)
    sendDirectMessageUseCase: ISendDirectMessageUseCase
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
      const [conversation, message] =
        await this.sendDirectMessageUseCase.execute(
          connection.locals.cognitoId,
          recipientId,
          text
        );
      connection.broadcast(
        `${connection.locals.cognitoId}:message`,
        {
          conversation: conversation,
          message: message,
        },
        recipientId
      );
      connection.success({
        conversation: conversation,
        message: message,
      });
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
