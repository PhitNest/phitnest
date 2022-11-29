import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import { ISendFriendRequestUseCase } from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IRelationshipController } from "../interfaces";

@injectable()
export class RelationshipController implements IRelationshipController {
  sendFriendRequestUseCase: ISendFriendRequestUseCase;

  constructor(
    @inject(UseCases.sendFriendRequest)
    sendFriendRequestUseCase: ISendFriendRequestUseCase
  ) {
    this.sendFriendRequestUseCase = sendFriendRequestUseCase;
  }

  async sendFriendRequest(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { recipientId } = z
        .object({
          recipientId: z.string(),
        })
        .parse(req.content());
      await this.sendFriendRequestUseCase.execute(
        res.locals.userId,
        recipientId
      );
      return res.status(200);
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(400).json({
          message: err.message,
        });
      } else if (err instanceof Error) {
        return res.status(500).json({
          message: err.message,
        });
      } else {
        return res.status(500).json(err);
      }
    }
  }
}
