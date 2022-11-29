import { AuthenticatedLocals, Controller } from "../../types";

export interface IRelationshipController {
  sendFriendRequest: Controller<AuthenticatedLocals>;
  block: Controller<AuthenticatedLocals>;
  unblock: Controller<AuthenticatedLocals>;
}
