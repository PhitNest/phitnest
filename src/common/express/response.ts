import express from "express";
import { IResponse } from "../../adapters/types";

/**
 * This is an express implementation of the response interface. This allows
 * controllers to be injected into the express router
 */
export class Response<LocalsType = any> implements IResponse<LocalsType> {
  locals: LocalsType;
  expressResponse: express.Response;
  code: number;
  content: any;

  constructor(expressResponse: express.Response) {
    this.expressResponse = expressResponse;
    this.locals = expressResponse.locals as LocalsType;
    this.code = 200;
  }

  status(code: number) {
    this.code = code;
    this.expressResponse.status(code);
    return this;
  }

  json(content: any) {
    this.content = content;
    this.expressResponse.json(content);
    return this;
  }
}
