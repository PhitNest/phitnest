import { AuthenticatedLocals, Controller } from "../../types";

export interface IDirectConversationController {
  getDirectConversations: Controller<AuthenticatedLocals>;
}
