import { injectable } from "inversify";
import { l } from "../../../common/logger";
import { IConnection } from "../../types";
import { ISendDirectMessageEventHandler } from "../interfaces";

@injectable()
export class SendDirectMessageEventHandler
  implements ISendDirectMessageEventHandler
{
  async execute(connection: IConnection, data: any) {
    l.info(data);
  }
}
