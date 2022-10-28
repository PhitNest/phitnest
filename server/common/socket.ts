import http from "http";
import { Server, Socket } from "socket.io";
import EventHandler from "../src/events/events";

export function registerSocketIO(app: http.Server) {
  const io = new Server(app);
  io.on("connection", (socket: Socket) => {
    const handler = new EventHandler(socket);
    handler.onConnect();
    socket.on("disconnect", handler.onDisconnect);
    handler.registerEvents();
  });
  return io;
}
