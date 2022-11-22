import express from "express";
import { IResponse } from "../../adapters/controllers";

/**
 * This is an express implementation of the response interface. This allows
 * controllers to be injected into the express router
 */
export class Response<ResType, LocalsType>
  implements IResponse<ResType, LocalsType>
{
  locals: LocalsType;
  expressResponse: express.Response;

  constructor(expressResponse: express.Response) {
    this.expressResponse = expressResponse;
    this.locals = expressResponse.locals as LocalsType;
  }

  status(code: number) {
    this.expressResponse.status(code);
    return this;
  }

  json(content: ResType) {
    this.expressResponse.json(content);
    return this;
  }
}
