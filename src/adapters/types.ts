export interface AuthenticatedLocals {
  userId: string;
}

export type Controller<LocalsType = any> = (
  req: IRequest,
  res: IResponse<LocalsType>
) => Promise<IResponse<LocalsType>>;

export type Middleware<LocalsType = any> = (
  req: IRequest,
  res: IResponse<LocalsType>,
  next: (err?: string) => void
) => Promise<void>;

export interface IResponse<LocalsType = any> {
  locals: LocalsType;

  status(code: number): this;
  json(content: any): this;
}

export interface IRequest {
  content(): any;
  authorization(): string | null;
}
