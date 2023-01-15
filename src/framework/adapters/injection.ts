import {
  ExpressServer,
  MongooseDatabase,
  SocketIOServer,
} from "./implementations";
import { IDatabase, IServer, ISocketServer } from "./interfaces";

let server: IServer;
let database: IDatabase;
let socketServer: ISocketServer;

export function getServer() {
  return server;
}

export function getDatabase() {
  return database;
}

export function getSocketServer() {
  return socketServer;
}

export function injectAdapters() {
  server = new ExpressServer();
  database = new MongooseDatabase();
  socketServer = new SocketIOServer();
}
