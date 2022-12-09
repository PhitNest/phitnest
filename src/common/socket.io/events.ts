import { Server, Socket } from "socket.io";
import { ExtendedError } from "socket.io/dist/namespace";
import {
  AuthenticatedLocals,
  IConnection,
  IEventHandler,
  IRequest,
  IResponse,
  MiddlewareController,
} from "../../adapters/types";
import { SendDirectMessageEvent, SendFriendRequestEvent } from "../../events";
import { IEvent } from "../../events/types";
import {
  dependencies,
  EventHandlers,
  Middlewares,
} from "../dependency-injection";
import { l } from "../logger";

class Connection implements IConnection {
  socket: Socket;
  locals: AuthenticatedLocals;
  id: string;

  constructor(socket: any) {
    this.socket = socket;
    this.locals = socket.locals;
    this.id = socket.id;
  }

  broadcast(event: string, data: any, room?: string) {
    if (room) {
      this.socket.broadcast.to(room).emit(event, data);
    } else {
      this.socket.broadcast.emit(event, data);
    }
  }

  async joinRoom(room: string) {
    return this.socket.join(room);
  }

  async leaveRoom(room: string) {
    return this.socket.leave(room);
  }

  send(event: string, data: any) {
    this.socket.emit(event, data);
  }

  disconnect() {
    this.socket.disconnect(true);
  }
}

class ConnectionRequest implements IRequest {
  socket: Socket;

  constructor(socket: Socket) {
    this.socket = socket;
  }

  content() {}

  authorization() {
    return this.socket.handshake.headers.token?.toString() ?? null;
  }
}

class ConnectionResponse implements IResponse<any> {
  socket: Socket;
  locals: any;
  code: any;
  content: any;

  constructor(socket: any) {
    this.socket = socket;
    socket.locals = {} as { cognitoId?: string };
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

function runEventHandler(
  eventHandler: IEventHandler,
  socket: Socket,
  data: any
) {
  l.info((typeof eventHandler).toString());
  return eventHandler.execute(new Connection(socket), data);
}

function buildMiddleware(io: Server, middleware: MiddlewareController) {
  io.use(
    async (socket: Socket, next: (err?: ExtendedError | undefined) => void) => {
      await middleware.execute(
        new ConnectionRequest(socket),
        new ConnectionResponse(socket),
        (err) => next(err ? new Error(err) : undefined)
      );
    }
  );
}

function bindEvent(socket: Socket, event: IEvent) {
  socket.on(event.name, (data) => runEventHandler(event.handler, socket, data));
}

export function buildMiddlewares(io: Server) {
  buildMiddleware(io, dependencies.get(Middlewares.authenticate));
}

export function runConnectionEvents(socket: Socket) {
  runEventHandler(dependencies.get(EventHandlers.onConnect), socket, null);
}

export function bindIncomingEvents(socket: Socket) {
  bindEvent(socket, dependencies.resolve(SendDirectMessageEvent));
  bindEvent(socket, dependencies.resolve(SendFriendRequestEvent));
}

export function runDisconnectEvents(socket: Socket) {
  runEventHandler(dependencies.get(EventHandlers.onDisconnect), socket, null);
}
