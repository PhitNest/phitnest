import { Socket } from "socket.io";
import l from "../../common/logger";

export function registerChat(socket: Socket): void {
  socket.on("sendMessage", sendMessage);
}

function sendMessage(data) {
  l.info(data);
}
