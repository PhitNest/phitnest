import http from "http";
import IO from "socket.io";
import repositories from "../../repositories/injection";
import { ISocketServer } from "../interfaces";

export class SocketIOServer implements ISocketServer {
  io: IO.Server | undefined;

  listen(server: http.Server) {
    this.io = new IO.Server(server);
    this.io.use((socket, next) => {
      const { authRepo } = repositories();
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

  kickUser(cognitoId: string) {
    this.io?.in(cognitoId).disconnectSockets();
  }
}
