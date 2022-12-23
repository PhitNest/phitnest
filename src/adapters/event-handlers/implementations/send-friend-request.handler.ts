import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import { IPublicUserEntity } from "../../../entities";
import {
  IGetUserUseCase,
  ISendFriendRequestUseCase,
} from "../../../use-cases/interfaces";
import { IConnection } from "../../types";
import { ISendFriendRequestEventHandler } from "../interfaces";

@injectable()
export class SendFriendRequestEventHandler
  implements ISendFriendRequestEventHandler
{
  sendFriendRequestUseCase: ISendFriendRequestUseCase;
  getUserUseCase: IGetUserUseCase;

  constructor(
    @inject(UseCases.sendFriendRequest)
    sendFriendRequestUseCase: ISendFriendRequestUseCase,
    getUserUseCase: IGetUserUseCase
  ) {
    this.getUserUseCase = getUserUseCase;
    this.sendFriendRequestUseCase = sendFriendRequestUseCase;
  }

  async execute(connection: IConnection, data: any) {
    try {
      const { recipientId } = z
        .object({
          recipientId: z.string(),
        })
        .parse(data);
      const [user, _] = await Promise.all([
        this.getUserUseCase.execute(connection.locals.cognitoId),
        this.sendFriendRequestUseCase.execute(
          connection.locals.cognitoId,
          recipientId
        ),
      ]);
      connection.broadcast(
        "friendRequest",
        user as IPublicUserEntity,
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
