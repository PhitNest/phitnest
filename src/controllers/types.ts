import { IRequest, IResponse } from "../common/types";

export type Controller<BodyType, ResType, LocalsType> = (
  req: IRequest<BodyType>,
  res: IResponse<ResType, LocalsType>
) => Promise<IResponse<ResType, LocalsType>>;
