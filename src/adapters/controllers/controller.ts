import { IRequest } from "./request";
import { IResponse } from "./response";

export type Controller<ReqType = any, ResType = any, LocalsType = any> = (
  req: IRequest<ReqType>,
  res: IResponse<ResType, LocalsType>
) => Promise<IResponse<ResType, LocalsType>>;
