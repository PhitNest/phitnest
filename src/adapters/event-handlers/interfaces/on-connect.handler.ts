import { EventExecutor, IEventHandler } from "../../types";

export interface IOnConnectEventHandler extends IEventHandler {
  execute: EventExecutor;
}
