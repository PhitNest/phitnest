import { injectable } from "inversify";
import { l } from "../../../common/logger";
import { IConnection } from "../../types";
import { IOnDisconnectEventHandler } from "../interfaces";

@injectable()
export class OnDisconnectEventHandler implements IOnDisconnectEventHandler {
  async execute(connection: IConnection) {
    l.info(`Disconnected: ${connection.locals.cognitoId}`);
  }
}
