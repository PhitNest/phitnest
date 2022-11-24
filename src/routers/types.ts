import { Controller, Middleware } from "../adapters/types";

export enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE,
}

export interface IRoute {
  method: HttpMethod;
  path: string;
  middlewares: Middleware[];
  controller: Controller;
}

export interface IRouter {
  routes: IRoute[];
}
