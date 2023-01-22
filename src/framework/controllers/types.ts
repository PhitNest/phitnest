import { Failure, IRequest, IResponse, Validator } from "../../common/types";
import { Middleware } from "../middleware/types";

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
