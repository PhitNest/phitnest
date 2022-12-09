import { inject, injectable } from "inversify";
import { ISendFriendRequestEventHandler } from "../adapters/event-handlers/interfaces";
import { EventHandlers } from "../common/dependency-injection";
import { IEvent } from "./types";

@injectable()
export class SendFriendRequestEvent implements IEvent {
  name = "friendRequest";
  handler: ISendFriendRequestEventHandler;

  constructor(
    @inject(EventHandlers.sendFriendRequest)
    sendFriendRequestHandler: ISendFriendRequestEventHandler
  ) {
    this.handler = sendFriendRequestHandler;
  }
}
