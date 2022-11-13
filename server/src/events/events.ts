import { Socket } from "socket.io";
import { registerChat } from "./chat.events";
import l from "../../common/logger";

export default class Events {
  socket: Socket;

  constructor(socket: Socket) {
    this.socket = socket;
  }

  onDisconnect(reason: string): void {
    l.info(`Disconnected: ${reason}`);
  }

  registerEvents(): void {
    registerChat(this.socket);
  }

  onConnect(): void {
    l.info("Connected");
  }
}
