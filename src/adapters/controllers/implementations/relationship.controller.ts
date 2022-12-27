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
  IRemoveFriendUseCase,
} from "../../../use-cases/interfaces";
import { AuthenticatedLocals, IRequest, IResponse } from "../../types";
import { IRelationshipController } from "../interfaces";
import {
  statusBadRequest,
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";

@injectable()
export class RelationshipController implements IRelationshipController {
  getReceivedFriendRequestsUseCase: IGetReceivedFriendRequestsUseCase;
  blockUseCase: IBlockUseCase;
  unblockUseCase: IUnblockUseCase;
  denyFriendRequestUseCase: IDenyFriendRequestUseCase;
  getFriendsUseCase: IGetFriendsUseCase;
  getSentFriendRequestsUseCase: IGetSentFriendRequestsUseCase;
  removeFriendUseCase: IRemoveFriendUseCase;

  constructor(
    @inject(UseCases.block) blockUseCase: IBlockUseCase,
    @inject(UseCases.unblock) unblockUseCase: IUnblockUseCase,
    @inject(UseCases.denyFriendRequest)
    denyFriendRequestUseCase: IDenyFriendRequestUseCase,
    @inject(UseCases.getFriends) getFriendsUseCase: IGetFriendsUseCase,
    @inject(UseCases.getSentFriendRequests)
    getSentFriendRequestsUseCase: IGetSentFriendRequestsUseCase,
    @inject(UseCases.getReceivedFriendRequests)
    getReceivedFriendRequestsUseCase: IGetReceivedFriendRequestsUseCase,
    @inject(UseCases.removeFriend) removeFriendUseCase: IRemoveFriendUseCase
  ) {
    this.blockUseCase = blockUseCase;
    this.unblockUseCase = unblockUseCase;
    this.denyFriendRequestUseCase = denyFriendRequestUseCase;
    this.getFriendsUseCase = getFriendsUseCase;
    this.getSentFriendRequestsUseCase = getSentFriendRequestsUseCase;
    this.getReceivedFriendRequestsUseCase = getReceivedFriendRequestsUseCase;
    this.removeFriendUseCase = removeFriendUseCase;
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
      return res.status(statusOK).json(friendRequests);
    } catch (err) {
      if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async removeFriend(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { recipientId } = z
        .object({
          recipientId: z.string(),
        })
        .parse(req.content());
      await this.removeFriendUseCase.execute(res.locals.cognitoId, recipientId);
      return res.status(statusOK).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
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
      return res.status(statusOK).json(friendRequests);
    } catch (err) {
      if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async getFriends(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const friends = await this.getFriendsUseCase.execute(
        res.locals.cognitoId
      );
      return res.status(statusOK).json(friends);
    } catch (err) {
      if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
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
      return res.status(statusOK).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async unblock(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { recipientId } = z
        .object({ recipientId: z.string() })
        .parse(req.content());
      await this.unblockUseCase.execute(res.locals.cognitoId, recipientId);
      return res.status(statusOK).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }

  async block(req: IRequest, res: IResponse<AuthenticatedLocals>) {
    try {
      const { recipientId } = z
        .object({ recipientId: z.string() })
        .parse(req.content());
      await this.blockUseCase.execute(res.locals.cognitoId, recipientId);
      return res.status(statusOK).send();
    } catch (err) {
      if (err instanceof z.ZodError) {
        return res.status(statusBadRequest).json(err.issues);
      } else if (err instanceof Error) {
        return res.status(statusInternalServerError).json(err.message);
      } else {
        return res.status(statusInternalServerError).send(err);
      }
    }
  }
}
