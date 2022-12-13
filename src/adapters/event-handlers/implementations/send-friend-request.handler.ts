import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import { ISendFriendRequestUseCase } from "../../../use-cases/interfaces";
import { IConnection } from "../../types";
import { ISendFriendRequestEventHandler } from "../interfaces";

@injectable()
export class SendFriendRequestEventHandler
  implements ISendFriendRequestEventHandler
{
  sendFriendRequestUseCase: ISendFriendRequestUseCase;

  constructor(
    @inject(UseCases.sendFriendRequest)
    sendFriendRequestUseCase: ISendFriendRequestUseCase
  ) {
    this.sendFriendRequestUseCase = sendFriendRequestUseCase;
  }

  async execute(connection: IConnection, data: any) {
    try {
      const { recipientId } = z
        .object({
          recipientId: z.string(),
        })
        .parse(data);
      await this.sendFriendRequestUseCase.execute(
        connection.locals.cognitoId,
        recipientId
      );
      connection.broadcast(
        "friendRequest",
        connection.locals.cognitoId,
        recipientId
      );
      connection.success(null);
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
