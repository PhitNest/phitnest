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
  error(data: any): void;
  success(data: any): void;
}

export interface AuthenticatedLocals {
  cognitoId: string;
}

export type AuthenticatedController<ResType = null> = Controller<
  ResType,
  AuthenticatedLocals
>;

export type Controller<ResType = null, LocalsType = any> = (
  req: IRequest,
  res: IResponse<ResType, LocalsType>
) => Promise<IResponse<ResType, LocalsType>>;

export interface MiddlewareController<LocalsType = any> {
  execute: (
    req: IRequest,
    res: IResponse<any, LocalsType>,
    next: (err?: string) => void
  ) => Promise<void>;
}

export type IAuthenticatedResponse<ResType = null> = IResponse<
  ResType,
  AuthenticatedLocals
>;

export interface IResponse<ResType = null, LocalsType = any> {
  locals: LocalsType;
  code: number;
  content: ResType;

  send(content?: any): this;
  status(code: number): this;
  json(content: ResType): this;
}

export interface IRequest {
  content(): any;
  authorization(): string | null;
}
