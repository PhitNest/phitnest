import { EventExecutor, IEventHandler } from "../../types";

export interface IOnDisconnectEventHandler extends IEventHandler {
  execute: EventExecutor;
}
