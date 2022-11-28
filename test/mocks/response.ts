import { IResponse } from "../../src/adapters/types";

export class MockResponse<LocalsType = any> implements IResponse<LocalsType> {
  locals: LocalsType;
  code: number;
  content: any;

  constructor(locals: LocalsType) {
    this.locals = locals;
    this.code = 200;
  }

  status(code: number) {
    this.code = code;
    return this;
  }

  json(content: any) {
    this.content = content;
    return this;
  }
}
