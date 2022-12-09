import { injectable } from "inversify";
import { IConnection } from "../../types";
import { IOnDisconnectEventHandler } from "../interfaces";

@injectable()
export class OnDisconnectEventHandler implements IOnDisconnectEventHandler {
  async execute(connection: IConnection) {}
}
