import { Socket } from "socket.io";
import l from "../../common/logger";

export default function (socket: Socket): void {
  socket.on("sendMessage", sendMessage);
}

function sendMessage(data) {
  l.info(data);
}
