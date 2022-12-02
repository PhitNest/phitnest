import { injectable } from "inversify";
import { l } from "../../../common/logger";
import { IConnection } from "../../types";
import { IOnConnectEventHandler } from "../interfaces";

@injectable()
export class OnConnectEventHandler implements IOnConnectEventHandler {
  async execute(connection: IConnection) {
    l.info(`Connected: ${connection.locals.cognitoId}`);
  }
}
