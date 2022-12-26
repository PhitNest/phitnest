import { inject, injectable } from "inversify";
import { ISendMessageEventHandler } from "../adapters/event-handlers/interfaces";
import { EventHandlers } from "../common/dependency-injection";
import { IEvent } from "./types";

@injectable()
export class SendMessageEvent implements IEvent {
  name = "message";
  handler: ISendMessageEventHandler;

  constructor(
    @inject(EventHandlers.sendMessage)
    sendMessageEventHandler: ISendMessageEventHandler
  ) {
    this.handler = sendMessageEventHandler;
  }
}
