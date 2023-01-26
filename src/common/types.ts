export class Failure {
  code: string;
  message: string;
  details: any;

  constructor(code: string, message: string, details?: any) {
    this.code = code;
    this.message = message;
    this.details = details;
  }
}

export type AuthenticatedLocals = {
  cognitoId: string;
};

export interface IRequest<BodyType = {}> {
  body: BodyType;
  authorization: string;
}

export interface IResponse<ResType, LocalsType = {}> {
  locals: LocalsType;
  setLocals<NewLocals>(newLocals: NewLocals): IResponse<ResType, NewLocals>;
}
