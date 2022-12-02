import { EventExecutor, IEventHandler } from "../../types";

export interface ISendDirectMessageEventHandler extends IEventHandler {
  execute: EventExecutor;
}
