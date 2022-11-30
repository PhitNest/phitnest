import express, { Router } from "express";
import { Container, interfaces } from "inversify";
import {
  Controller,
  IRequest,
  IResponse,
  Middleware,
} from "../../adapters/types";
import {
  AuthRouter,
  GymRouter,
  RelationshipRouter,
  UserRouter,
} from "../../routers";
import { HttpMethod, IRouter } from "../../routers/types";
import { dependencies } from "../dependency-injection";

export function buildRoutes(dependencies: Container) {
  const router = Router();
  router.use("/gym", buildRoute(GymRouter));
  router.use("/user", buildRoute(UserRouter));
  router.use("/auth", buildRoute(AuthRouter));
  router.use("/relationship", buildRoute(RelationshipRouter));
  return router;
}

class Response<LocalsType = any> implements IResponse<LocalsType> {
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

function buildMiddleware(middlewares: Middleware[]) {
  return middlewares.map(
    (middleware) =>
      async function (
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
      ) {
        await middleware(new Request(req), new Response(res), next);
      }
  );
}

class Request implements IRequest {
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

function buildController(controller: Controller) {
  return async function (req: express.Request, res: express.Response) {
    await controller(new Request(req), new Response(res));
  };
}

function buildRoute(routerClass: interfaces.Newable<IRouter>) {
  const expressRouter = Router();
  const router = dependencies.resolve(routerClass);
  router.routes.forEach((route) => {
    const middlewares = buildMiddleware(route.middlewares);
    const controller = buildController(route.controller);
    switch (route.method) {
      case HttpMethod.GET:
        expressRouter.get(route.path, middlewares, controller);
        break;
      case HttpMethod.POST:
        expressRouter.post(route.path, middlewares, controller);
        break;
      case HttpMethod.PUT:
        expressRouter.put(route.path, middlewares, controller);
        break;
      case HttpMethod.DELETE:
        expressRouter.delete(route.path, middlewares, controller);
        break;
    }
  });
  return expressRouter;
}
