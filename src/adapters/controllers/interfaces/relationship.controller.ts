import { z } from "zod";
import { IFriendEntity, IPublicUserEntity } from "../../../entities";
import { AuthenticatedController } from "../../types";

export interface IRelationshipController {
  block: AuthenticatedController;
  unblock: AuthenticatedController;
  denyFriendRequest: AuthenticatedController;
  getFriends: AuthenticatedController<IFriendEntity[]>;
  getSentFriendRequests: AuthenticatedController<IPublicUserEntity[]>;
  getReceivedFriendRequests: AuthenticatedController<IPublicUserEntity[]>;
  removeFriend: AuthenticatedController;
}
