import { IRequest } from "../../adapters/controllers";
import express from "express";

/**
 * This is an express implementation of the request interface. This allows
 * controllers to be injected into the express router
 */
export class Request implements IRequest {
  expressRequest: express.Request;

  constructor(expressRequest: express.Request) {
    this.expressRequest = expressRequest;
  }

  content() {
    return {
      ...this.expressRequest.body,
      ...this.expressRequest.query,
      ...this.expressRequest.params,
    };
  }
  authorization() {
    return this.expressRequest.headers.authorization ?? "";
  }
}
