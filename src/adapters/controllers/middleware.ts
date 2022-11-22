import { IRequest } from "./request";
import { IResponse } from "./response";

export type Middleware<ReqType = any, ResType = any, LocalsType = any> = (
  req: IRequest<ReqType>,
  res: IResponse<ResType, LocalsType>,
  next: (err?: string) => void
) => Promise<void>;
