import { ISocketServer } from "./adapters/interfaces";
import {
  handleSendDirectMessage,
  validateSendDirectMessage,
} from "./event-handlers";

export function bindEvents(socketServer: ISocketServer) {
  socketServer.bind(
    "directMessage",
    validateSendDirectMessage,
    handleSendDirectMessage
  );
}
