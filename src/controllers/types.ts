import { Failure, IRequest, IResponse } from "../common/types";
import { Middleware } from "../middleware/types";

type Validator<BodyType> = (body: any) => BodyType;

export enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE,
  PATCH,
}

export interface Controller<BodyType, ResType, LocalsType = {}> {
  method: HttpMethod;

  middleware?: Middleware<BodyType, ResType, any>[];

  execute(
    req: IRequest<BodyType>,
    res: IResponse<ResType, LocalsType>
  ): Promise<ResType | Failure>;

  validate: Validator<BodyType>;
}
