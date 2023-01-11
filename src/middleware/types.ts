import { Failure, IRequest, IResponse } from "../common/types";

export type Middleware<BodyType, ResType, LocalsType> = (
  req: IRequest<BodyType>,
  res: IResponse<ResType, LocalsType>,
  next: (failure?: Failure) => void
) => Promise<void>;
