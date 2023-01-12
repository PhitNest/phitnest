export class Failure {
  code: string;
  message: string;

  constructor(code: string, message: string) {
    this.code = code;
    this.message = message;
  }
}

export type AuthenticatedLocals = {
  cognitoId: string;
};

export interface IRequest<BodyType> {
  body: BodyType;
  authorization: string;
}

export interface IResponse<ResType, LocalsType = {}> {
  locals: LocalsType;
  setLocals<NewLocals>(newLocals: NewLocals): IResponse<ResType, NewLocals>;
}
