import { Either } from "typescript-monads";

export class Either3<A, B, C> extends Either<Either<A, B>, C> {
  constructor(left?: A, middle?: B, right?: C) {
    super(new Either(left, middle), right);
  }
}

export enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE,
  PATCH,
}

export interface Failure {
  code: string;
  message: string;
}

export interface IRequest<BodyType> {
  body: BodyType;
  authorization: string;
}

export interface IResponse<ResType, LocalsType> {
  locals: LocalsType;
  status(code: number): IResponse<ResType, LocalsType>;
  json(data: Either<ResType, Failure>): IResponse<ResType, LocalsType>;
  setLocals<NewLocals>(newLocals: NewLocals): IResponse<ResType, NewLocals>;
}
