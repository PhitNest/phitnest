import { AuthenticatedLocals, Controller } from "../../types";

export interface IConversationController {
  getRecentConversations: Controller<AuthenticatedLocals>;
}
