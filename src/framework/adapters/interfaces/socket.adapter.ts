import http from "http";
import { EventHandler } from "../../event-handlers/types";

export interface IConnection {
  cognitoId: string;

  joinRoom(room: string): void;

  kick(): void;

  broadcast(event: string, body: any, room?: string): void;
}

export interface ISocketServer {
  listen(server: http.Server): void;

  bind(handler: EventHandler<any>): void;

  emit(event: string, body: any, room?: string): void;

  kickUser(cognitoId: string): void;
}
