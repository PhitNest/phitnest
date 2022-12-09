import { inject, injectable } from "inversify";
import { z } from "zod";
import { UseCases } from "../../../common/dependency-injection";
import {
  IBlockUseCase,
  IDenyFriendRequestUseCase,
  IGetFriendsUseCase,
  IUnblockUseCase,
  IGetSentFriendRequestsUseCase,
  IGetReceivedFriendRequestsUseCase,
} from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IRelationshipController } from "../interfaces";

@injectable()
export class RelationshipController implements IRelationshipController {
  getReceivedFriendRequestsUseCase: IGetReceivedFriendRequestsUseCase;
  blockUseCase: IBlockUseCase;
  unblockUseCase: IUnblockUseCase;
  denyFriendRequestUseCase: IDenyFriendRequestUseCase;
  getFriendsUseCase: IGetFriendsUseCase;
  getSentFriendRequestsUseCase: IGetSentFriendRequestsUseCase;

  constructor(
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
      if (err instanceof Error) {
        return res.status(500).json(err.message);
      } else {
        return res.status(500).send(err);
      }
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
      if (err instanceof Error) {
        return res.status(500).json(err.message);
      } else {
        return res.status(500).send(err);
      }
    }
  }

  async getFriends(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const friends = await this.getFriendsUseCase.execute(
        res.locals.cognitoId
      );
      return res.status(200).json(friends);
    } catch (err) {
      if (err instanceof Error) {
        return res.status(500).json(err.message);
      } else {
        return res.status(500).send(err);
      }
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
        return res.status(400).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(500).json(err.message);
      } else {
        return res.status(500).send(err);
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
        return res.status(400).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(500).json(err.message);
      } else {
        return res.status(500).send(err);
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
        return res.status(400).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(500).json(err.message);
      } else {
        return res.status(500).send(err);
      }
    }
  }
}
