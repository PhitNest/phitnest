export interface IEventHandler {
  execute: EventExecutor;
}

export type EventExecutor = (
  connection: IConnection,
  data: any
) => Promise<void>;

export interface IConnection {
  locals: AuthenticatedLocals;
  id: string;
  disconnect(): void;
  broadcast(event: string, data: any, room?: string): void;
  joinRoom(room: string): Promise<void>;
  leaveRoom(room: string): Promise<void>;
  send(event: string, data: any, room?: string): void;
}

export interface AuthenticatedLocals {
  cognitoId: string;
}

export type Controller<LocalsType = any> = (
  req: IRequest,
  res: IResponse<LocalsType>
) => Promise<IResponse<LocalsType>>;

export interface MiddlewareController<LocalsType = any> {
  execute: (
    req: IRequest,
    res: IResponse<LocalsType>,
    next: (err?: string) => void
  ) => Promise<void>;
}

export interface IResponse<LocalsType = any> {
  locals: LocalsType;
  code: number;
  content: any;

  send(): this;
  status(code: number): this;
  json(content: any): this;
}

export interface IRequest {
  content(): any;
  authorization(): string | null;
}
