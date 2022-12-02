import { inject, injectable } from "inversify";
import { ISendDirectMessageEventHandler } from "../adapters/event-handlers/interfaces";
import { EventHandlers } from "../common/dependency-injection";
import { IEvent } from "./types";

@injectable()
export class SendDirectMessageEvent implements IEvent {
  name = "sendDirectMessage";
  handler: ISendDirectMessageEventHandler;

  constructor(
    @inject(EventHandlers.sendDirectMessage)
    sendDirectMessageHandler: ISendDirectMessageEventHandler
  ) {
    this.handler = sendDirectMessageHandler;
  }
}
