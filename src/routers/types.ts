import { Controller, MiddlewareController } from "../adapters/types";

export enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE,
}

export interface IRoute {
  method: HttpMethod;
  path: string;
  middlewares: MiddlewareController[];
  controller: Controller;
}

export interface IRouter {
  routes: IRoute[];
}
