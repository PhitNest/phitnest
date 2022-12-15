import { inject, injectable } from "inversify";
import { ISendDirectMessageEventHandler } from "../adapters/event-handlers/interfaces";
import { EventHandlers } from "../common/dependency-injection";
import { IEvent } from "./types";

@injectable()
export class SendMessageEvent implements IEvent {
  name = "directMessage";
  handler: ISendDirectMessageEventHandler;

  constructor(
    @inject(EventHandlers.sendDirectMessage)
    sendMessageHandler: ISendDirectMessageEventHandler
  ) {
    this.handler = sendMessageHandler;
  }
}
