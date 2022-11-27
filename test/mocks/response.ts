import { IResponse } from "../../src/adapters/types";

export class MockResponse<LocalsType = any> implements IResponse<LocalsType> {
  locals: LocalsType;
  code: number;
  body: any;

  constructor(locals: LocalsType) {
    this.locals = locals;
    this.code = 200;
    this.body = {};
  }

  status(code: number) {
    this.code = code;
    return this;
  }

  json(body: any) {
    this.body = body;
    return this;
  }
}
