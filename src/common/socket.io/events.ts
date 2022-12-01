import { Server, Socket } from "socket.io";
import { ExtendedError } from "socket.io/dist/namespace";
import {
  IRequest,
  IResponse,
  MiddlewareController,
} from "../../adapters/types";
import { dependencies, Middlewares } from "../dependency-injection";
import { l } from "../logger";

export class ConnectionRequest implements IRequest {
  socket: Socket;

  constructor(socket: Socket) {
    this.socket = socket;
  }

  content() {}

  authorization() {
    return this.socket.handshake.headers.token?.toString() ?? null;
  }
}

export class ConnectionResponse implements IResponse<any> {
  socket: Socket;
  locals: any;
  code: any;
  content: any;

  constructor(socket: any) {
    this.socket = socket;
    socket.locals = {} as { userId?: string };
    this.locals = socket.locals;
  }

  send() {
    return this;
  }

  status(code: number) {
    return this;
  }

  json(content: any) {
    return this;
  }
}

function buildMiddleware(middleware: MiddlewareController) {
  return async function (
    socket: Socket,
    next: (err?: ExtendedError | undefined) => void
  ) {
    await middleware.execute(
      new ConnectionRequest(socket),
      new ConnectionResponse(socket),
      (err) => next(err ? new Error(err) : undefined)
    );
  };
}

export function buildMiddlewares(io: Server) {
  io.use(buildMiddleware(dependencies.get(Middlewares.authenticate)));
}

export function runConnectionEvents(connection: Socket) {}

export function bindIncomingEvents(connection: Socket) {}

export function runDisconnectEvents(connection: Socket) {}
