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
import { IAuthenticatedResponse, IRequest } from "../../types";
import { IRelationshipController } from "../interfaces";
import {
  statusInternalServerError,
  statusOK,
} from "../../../constants/http_codes";
import { IFriendEntity, IPublicUserEntity } from "../../../entities";

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
    res: IAuthenticatedResponse<IPublicUserEntity[]>
  ) {
    try {
      const friendRequests =
        await this.getReceivedFriendRequestsUseCase.execute(
          res.locals.cognitoId
        );
      return res.status(statusOK).json(friendRequests);
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async removeFriend(req: IRequest, res: IAuthenticatedResponse) {
    try {
      const { recipientId } = z
        .object({
          recipientId: z.string(),
        })
        .parse(req.content());
      await this.removeFriendUseCase.execute(res.locals.cognitoId, recipientId);
      return res.status(statusOK).send();
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async getSentFriendRequests(
    req: IRequest,
    res: IAuthenticatedResponse<IPublicUserEntity[]>
  ) {
    try {
      const friendRequests = await this.getSentFriendRequestsUseCase.execute(
        res.locals.cognitoId
      );
      return res.status(statusOK).json(friendRequests);
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async getFriends(
    req: IRequest,
    res: IAuthenticatedResponse<IFriendEntity[]>
  ) {
    try {
      const friends = await this.getFriendsUseCase.execute(
        res.locals.cognitoId
      );
      return res.status(statusOK).json(friends);
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async denyFriendRequest(req: IRequest, res: IAuthenticatedResponse) {
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
      return res.status(statusInternalServerError).send(err);
    }
  }

  async unblock(req: IRequest, res: IAuthenticatedResponse) {
    try {
      const { recipientId } = z
        .object({ recipientId: z.string() })
        .parse(req.content());
      await this.unblockUseCase.execute(res.locals.cognitoId, recipientId);
      return res.status(statusOK).send();
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }

  async block(req: IRequest, res: IAuthenticatedResponse) {
    try {
      const { recipientId } = z
        .object({ recipientId: z.string() })
        .parse(req.content());
      await this.blockUseCase.execute(res.locals.cognitoId, recipientId);
      return res.status(statusOK).send();
    } catch (err) {
      return res.status(statusInternalServerError).send(err);
    }
  }
}
