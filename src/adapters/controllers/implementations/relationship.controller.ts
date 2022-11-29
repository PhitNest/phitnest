import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  IBlockUseCase,
  ISendFriendRequestUseCase,
  IUnblockUseCase,
} from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IRelationshipController } from "../interfaces";

@injectable()
export class RelationshipController implements IRelationshipController {
  sendFriendRequestUseCase: ISendFriendRequestUseCase;
  blockUseCase: IBlockUseCase;
  unblockUseCase: IUnblockUseCase;

  constructor(
    @inject(UseCases.sendFriendRequest)
    sendFriendRequestUseCase: ISendFriendRequestUseCase,
    @inject(UseCases.block) blockUseCase: IBlockUseCase,
    @inject(UseCases.unblock) unblockUseCase: IUnblockUseCase
  ) {
    this.sendFriendRequestUseCase = sendFriendRequestUseCase;
    this.blockUseCase = blockUseCase;
    this.unblockUseCase = unblockUseCase;
  }

  async unblock(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { recipientId } = z
        .object({ recipientId: z.string() })
        .parse(req.content());
      await this.unblockUseCase.execute(res.locals.userId, recipientId);
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

  async block(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { recipientId } = z
        .object({ recipientId: z.string() })
        .parse(req.content());
      await this.blockUseCase.execute(res.locals.userId, recipientId);
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
