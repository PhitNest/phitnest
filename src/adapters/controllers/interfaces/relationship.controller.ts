import { AuthenticatedLocals, Controller } from "../../types";

export interface IRelationshipController {
  sendFriendRequest: Controller<AuthenticatedLocals>;
  block: Controller<AuthenticatedLocals>;
  unblock: Controller<AuthenticatedLocals>;
  denyFriendRequest: Controller<AuthenticatedLocals>;
  getFriends: Controller<AuthenticatedLocals>;
  getSentFriendRequests: Controller<AuthenticatedLocals>;
  getReceivedFriendRequests: Controller<AuthenticatedLocals>;
}
