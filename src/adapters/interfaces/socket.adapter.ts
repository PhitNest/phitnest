import http from "http";

export interface ISocketServer {
  listen(server: http.Server): void;

  emit(event: string, body: any, room?: string): void;

  kickUser(cognitoId: string): void;
}
