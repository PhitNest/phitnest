import { AuthenticatedLocals, Controller } from "../../types";

export interface IDirectConversationController {
  getRecentDirectConversations: Controller<AuthenticatedLocals>;
}
