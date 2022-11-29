import { AuthenticatedLocals, Controller } from "../../types";

export interface IRelationshipController {
  sendFriendRequest: Controller<AuthenticatedLocals>;
}
