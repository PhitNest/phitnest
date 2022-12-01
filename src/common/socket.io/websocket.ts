import { Server } from "socket.io";
import http from "http";
import {
  bindIncomingEvents,
  buildMiddlewares,
  runConnectionEvents,
  runDisconnectEvents,
} from "./events";

let io: Server;

export function openSocket(httpServer: http.Server) {
  return new Promise((resolve) => {
    io = new Server(httpServer);
    buildMiddlewares(io);
    io.on("connection", (socket) => {
      runConnectionEvents(socket);
      bindIncomingEvents(socket);
      socket.on("disconnect", () => {
        runDisconnectEvents(socket);
      });
    });
    resolve(io);
  });
}

export function closeSocket() {
  return new Promise((resolve) => {
    io.close((err) => {
      resolve(err);
    });
  });
}
