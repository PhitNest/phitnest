import { ExpressServer, MongooseDatabase } from "./implementations";
import { IDatabase, IServer } from "./interfaces";

let server: IServer;
let database: IDatabase;

export function getServer() {
  return server;
}

export function getDatabase() {
  return database;
}

export function injectAdapters() {
  server = new ExpressServer();
  database = new MongooseDatabase();
}
