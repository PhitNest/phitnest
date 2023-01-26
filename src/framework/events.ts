import { ISocketServer } from "./adapters/interfaces";
import { SendDirectMessageHandler } from "./event-handlers";

export function bindEvents(socketServer: ISocketServer) {
  socketServer.bind(new SendDirectMessageHandler());
}
