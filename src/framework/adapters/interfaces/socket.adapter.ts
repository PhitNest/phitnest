import http from "http";
import { Validator } from "../../../common/types";
import { EventHandler } from "../../event-handlers/types";

export interface IConnection {
  cognitoId: string;

  joinRoom(room: string): void;

  kick(): void;

  broadcast(event: string, body: any, room?: string): void;
}

export interface ISocketServer {
  listen(server: http.Server): void;

  bind<DataType>(
    event: string,
    validator: Validator<DataType>,
    handler: EventHandler<DataType, any>
  ): void;

  emit(event: string, body: any, room?: string): void;

  kickUser(cognitoId: string): void;
}
