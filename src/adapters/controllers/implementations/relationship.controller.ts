import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  IBlockUseCase,
  IDenyFriendRequestUseCase,
  IGetFriendsUseCase,
  ISendFriendRequestUseCase,
  IUnblockUseCase,
  IGetSentFriendRequestsUseCase,
  IGetReceivedFriendRequestsUseCase,
} from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IRelationshipController } from "../interfaces";

@injectable()
export class RelationshipController implements IRelationshipController {
  getReceivedFriendRequestsUseCase: IGetReceivedFriendRequestsUseCase;
  sendFriendRequestUseCase: ISendFriendRequestUseCase;
  blockUseCase: IBlockUseCase;
  unblockUseCase: IUnblockUseCase;
  denyFriendRequestUseCase: IDenyFriendRequestUseCase;
  getFriendsUseCase: IGetFriendsUseCase;
  getSentFriendRequestsUseCase: IGetSentFriendRequestsUseCase;

  constructor(
    @inject(UseCases.sendFriendRequest)
    sendFriendRequestUseCase: ISendFriendRequestUseCase,
    @inject(UseCases.block) blockUseCase: IBlockUseCase,
    @inject(UseCases.unblock) unblockUseCase: IUnblockUseCase,
    @inject(UseCases.denyFriendRequest)
    denyFriendRequestUseCase: IDenyFriendRequestUseCase,
    @inject(UseCases.getFriends) getFriendsUseCase: IGetFriendsUseCase,
    @inject(UseCases.getSentFriendRequests)
    getSentFriendRequestsUseCase: IGetSentFriendRequestsUseCase,
    @inject(UseCases.getReceivedFriendRequests)
    getReceivedFriendRequestsUseCase: IGetReceivedFriendRequestsUseCase
  ) {
    this.sendFriendRequestUseCase = sendFriendRequestUseCase;
    this.blockUseCase = blockUseCase;
    this.unblockUseCase = unblockUseCase;
    this.denyFriendRequestUseCase = denyFriendRequestUseCase;
    this.getFriendsUseCase = getFriendsUseCase;
    this.getSentFriendRequestsUseCase = getSentFriendRequestsUseCase;
    this.getReceivedFriendRequestsUseCase = getReceivedFriendRequestsUseCase;
  }

  async getReceivedFriendRequests(
    req: IRequest,
    res: IResponse<AuthenticatedLocals>
  ) {
    try {
      const friendRequests =
        await this.getReceivedFriendRequestsUseCase.execute(
          res.locals.cognitoId
        );
      return res.status(200).json(friendRequests);
    } catch (err) {
      return res.status(500).json(err);
    }
  }

  async getSentFriendRequests(
    req: IRequest,
    res: IResponse<AuthenticatedLocals>
  ) {
    try {
      const friendRequests = await this.getSentFriendRequestsUseCase.execute(
        res.locals.cognitoId
      );
      return res.status(200).json(friendRequests);
    } catch (err) {
      return res.status(500).json(err);
    }
  }

  async getFriends(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const friends = await this.getFriendsUseCase.execute(
        res.locals.cognitoId
      );
      return res.status(200).json(friends);
    } catch (err) {
      return res.status(500).json(err);
    }
  }

  async denyFriendRequest(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { recipientId } = z
        .object({
          recipientId: z.string(),
        })
        .parse(req.content());
      await this.denyFriendRequestUseCase.execute(
        res.locals.cognitoId,
        recipientId
      );
      return res.status(200).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(400).json({
          message: err.message,
        });
      } else {
        return res.status(500).json(err);
      }
    }
  }

  async unblock(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { recipientId } = z
        .object({ recipientId: z.string() })
        .parse(req.content());
      await this.unblockUseCase.execute(res.locals.cognitoId, recipientId);
      return res.status(200).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(400).json({
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
      await this.blockUseCase.execute(res.locals.cognitoId, recipientId);
      return res.status(200).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(400).json({
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
        res.locals.cognitoId,
        recipientId
      );
      return res.status(200).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(400).json({
          message: err.message,
        });
      } else {
        return res.status(500).json(err);
      }
    }
  }
}