import { IRequest, IResponse, MiddlewareController } from "../../types";

export interface IAuthMiddleware<LocalsType = any>
  extends MiddlewareController<LocalsType> {
  execute: (
    req: IRequest,
    res: IResponse<LocalsType>,
    next: (err?: string) => void
  ) => Promise<void>;
}
