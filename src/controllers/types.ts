import { IRequest, IResponse } from "../common/types";

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

  execute(
    req: IRequest<BodyType>,
    res: IResponse<ResType, LocalsType>
  ): Promise<IResponse<ResType, LocalsType>>;

  validate: Validator<BodyType>;
}
