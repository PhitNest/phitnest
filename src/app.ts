import { closeSocket, openSocket } from "./common/socket.io";
import { connect, disconnect } from "./common/database";
import { injectDependencies, unbind } from "./common/dependency-injection";
import { createServer, listen, stopServer } from "./common/express";

export async function start() {
  return connect()
    .then(injectDependencies)
    .then(createServer)
    .then(openSocket)
    .then(listen);
}

export async function stop() {
  return disconnect().then(unbind).then(closeSocket).then(stopServer);
}
