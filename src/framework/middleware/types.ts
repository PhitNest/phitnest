import { Failure, IRequest, IResponse } from "../../common/types";

export type Middleware = (
  req: IRequest<any>,
  res: IResponse<any, {}>,
  next: (failure?: Failure) => void
) => Promise<void>;
