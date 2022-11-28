import { connect, disconnect } from "./common/database";
import { injectDependencies, unbind } from "./common/dependency-injection";
import { createServer, stopServer } from "./common/express";
import dotenv from "dotenv";
dotenv.config();

export async function start() {
  return connect().then(injectDependencies).then(createServer);
}

export async function stop() {
  return disconnect().then(unbind).then(stopServer);
}
