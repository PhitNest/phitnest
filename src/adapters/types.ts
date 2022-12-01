export interface AuthenticatedLocals {
  userId: string;
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
