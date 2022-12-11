import express, { Router } from "express";
import { interfaces } from "inversify";
import {
  Controller,
  IRequest,
  IResponse,
  MiddlewareController,
} from "../../adapters/types";
import {
  AuthRouter,
  DirectConversationRouter,
  GymRouter,
  DirectMessageRouter,
  RelationshipRouter,
  UserRouter,
} from "../../routers";
import { HttpMethod, IRouter } from "../../routers/types";
import { dependencies } from "../dependency-injection";

export function buildRoutes() {
  const router = Router();
  buildRoute(router, "/gym", GymRouter);
  buildRoute(router, "/user", UserRouter);
  buildRoute(router, "/auth", AuthRouter);
  buildRoute(router, "/relationship", RelationshipRouter);
  buildRoute(router, "/directMessage", DirectMessageRouter);
  buildRoute(router, "/directConversation", DirectConversationRouter);
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
    this.code = statusOK;
  }

  send(content?: any) {
    this.expressResponse.send(content);
    return this;
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

function buildMiddleware(middlewares: MiddlewareController[]) {
  return middlewares.map(
    (middleware) =>
      async function (
        req: express.Request,
        res: express.Response,
        next: express.NextFunction
      ) {
        await middleware.execute(new Request(req), new Response(res), next);
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

function buildRoute(
  expressRouter: Router,
  path: string,
  routerClass: interfaces.Newable<IRouter>
) {
  const router = dependencies.resolve(routerClass);
  const subRouter = Router();
  router.routes.forEach((route) => {
    const middlewares = buildMiddleware(route.middlewares);
    const controller = buildController(route.controller);
    switch (route.method) {
      case HttpMethod.GET:
        subRouter.get(route.path, middlewares, controller);
        break;
      case HttpMethod.POST:
        subRouter.post(route.path, middlewares, controller);
        break;
      case HttpMethod.PUT:
        subRouter.put(route.path, middlewares, controller);
        break;
      case HttpMethod.DELETE:
        subRouter.delete(route.path, middlewares, controller);
        break;
    }
  });
  expressRouter.use(path, subRouter);
}
