import { z } from "zod";
import { Failure, IRequest, IResponse } from "../../common/types";
import { Middleware } from "../middleware/types";

export enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE,
  PATCH,
}

export interface Controller<ResType> {
  route: string;

  validator?: z.ZodObject<any>;

  method: HttpMethod;

  middleware?: Middleware[];

  execute(
    req: IRequest,
    res: IResponse<ResType, any>
  ): Promise<ResType | Failure>;
}
