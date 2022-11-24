export interface AuthenticatedLocals {
  userId: string;
}

export type Controller = (req: IRequest, res: IResponse) => Promise<IResponse>;

export type Middleware = (
  req: IRequest,
  res: IResponse,
  next: (err?: string) => void
) => Promise<void>;

export interface IResponse<LocalsType = any> {
  locals: LocalsType;

  status(code: number): this;
  json(content: any): this;
}

export interface IRequest {
  content(): any;
  authorization(): string;
}
