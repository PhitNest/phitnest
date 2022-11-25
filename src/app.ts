import { connect, disconnect } from "./common/database";
import { inject, unbind } from "./common/dependency-injection";
import { createServer, stopServer } from "./common/express/server";
import dotenv from "dotenv";
dotenv.config();

export async function start() {
  return connect().then(inject).then(createServer);
}

export async function stop() {
  return disconnect().then(unbind).then(stopServer);
}
