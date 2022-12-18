import { AuthenticatedLocals, Controller } from "../../types";

export interface IMessageController {
  getMessages: Controller<AuthenticatedLocals>;
}
