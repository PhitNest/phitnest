import { IMessageEntity } from "../../../entities";
import { AuthenticatedController } from "../../types";

export interface IMessageController {
  getMessages: AuthenticatedController<IMessageEntity[]>;
}
