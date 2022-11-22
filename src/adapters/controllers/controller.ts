import { IRequest } from "./request";
import { IResponse } from "./response";

export type Controller<LocalsType = any> = (
  req: IRequest,
  res: IResponse<LocalsType>
) => Promise<IResponse<LocalsType>>;
