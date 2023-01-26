import http from "http";
import IO from "socket.io";
import { Failure } from "../../../common/types";
import { authRepo } from "../../../domain/repositories";
import { EventHandler } from "../../event-handlers/types";
import { IConnection, ISocketServer } from "../interfaces";

class SocketIOConnection implements IConnection {
  socket: IO.Socket;

  constructor(socket: IO.Socket) {
    this.socket = socket;
  }

  get cognitoId() {
    return this.socket.data.cognitoId;
  }

  joinRoom(room: string) {
    this.socket.join(room);
  }

  kick() {
    this.socket.disconnect();
  }

  broadcast(event: string, body: any) {
    this.socket.broadcast.emit(event, body);
  }
}

export class SocketIOServer implements ISocketServer {
  io: IO.Server | undefined;
  bindings: EventHandler<any>[] = [];

  listen(server: http.Server) {
    this.io = new IO.Server(server);
    this.io.use((socket, next) => {
      const token = socket.handshake.headers["token"];
      if (token) {
        authRepo.getCognitoId(token as string).then((cognitoId) => {
          socket.data.cognitoId = cognitoId;
          next();
        });
      } else {
        next(new Error("Unauthorized"));
      }
    });
    this.io.on("connection", (socket) => {
      console.log("Client connected");
      socket.join(socket.data.cognitoId);
      this.bindings.forEach((binding) => {
        socket.on(binding.event, async (data) => {
          try {
            let validationResult;
            if (binding.validator) {
              validationResult = binding.validator.parse(data);
            }
            const result = await binding.execute(
              validationResult,
              new SocketIOConnection(socket)
            );
            if (result instanceof Failure) {
              socket.emit("error", result);
            } else {
              socket.emit("success", result);
            }
          } catch (error: any) {
            socket.emit("error", error);
          }
        });
      });
      socket.on("disconnect", () => {
        console.log("Client disconnected");
      });
    });
  }

  emit(event: string, body: any, room?: string) {
    if (room) {
      this.io?.to(room).emit(event, body);
    } else {
      this.io?.emit(event, body);
    }
  }

  bind(handler: EventHandler<any>) {
    this.bindings.push(handler);
  }

  kickUser(cognitoId: string) {
    this.io?.in(cognitoId).disconnectSockets();
  }
}
