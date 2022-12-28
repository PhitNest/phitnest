import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
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
    @inject(UseCases.getUser)
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
        {
          firstName: user.firstName,
          lastName: user.lastName,
          cognitoId: user.cognitoId,
          _id: user._id,
          gymId: user.gymId,
        },
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
