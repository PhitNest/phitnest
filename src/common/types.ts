export class Failure {
  code: string;
  message: string;

  constructor(code: string, message: string) {
    this.code = code;
    this.message = message;
  }
}

export interface IRequest<BodyType> {
  body: BodyType;
  authorization: string;
}

export interface IResponse<ResType, LocalsType = {}> {
  locals: LocalsType;
  status(code: number): IResponse<ResType, LocalsType>;
  json(data: ResType | Failure): IResponse<ResType, LocalsType>;
  setLocals<NewLocals>(newLocals: NewLocals): IResponse<ResType, NewLocals>;
}
