import { IRequest } from "./request";
import { IResponse } from "./response";

export type Middleware<LocalsType = any> = (
  req: IRequest,
  res: IResponse<LocalsType>,
  next: (err?: string) => void
) => Promise<void>;
