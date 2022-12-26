import { EventExecutor, IEventHandler } from "../../types";

export interface ISendMessageEventHandler extends IEventHandler {
  execute: EventExecutor;
}
