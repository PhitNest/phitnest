import { Router } from "express";
import { Container } from "inversify";
import { AuthRouter, GymRouter, UserRouter } from "../../routers";
import { HttpMethod, IRouter } from "../../routers/types";
import { buildController } from "./controller";
import { buildMiddleware } from "./middleware";

export function buildRoutes(dependencies: Container) {
  const router = Router();
  buildRoute(router, dependencies.resolve(GymRouter));
  buildRoute(router, dependencies.resolve(UserRouter));
  buildRoute(router, dependencies.resolve(AuthRouter));
  return router;
}

function buildRoute(expressRouter: Router, router: IRouter) {
  router.routes.forEach((route) => {
    const middlewares = buildMiddleware(route.middlewares);
    const controller = buildController(route.controller);
    switch (route.method) {
      case HttpMethod.GET:
        return expressRouter.get(route.path, middlewares, controller);
      case HttpMethod.POST:
        return expressRouter.post(route.path, middlewares, controller);
      case HttpMethod.PUT:
        return expressRouter.put(route.path, middlewares, controller);
      case HttpMethod.DELETE:
        return expressRouter.delete(route.path, middlewares, controller);
    }
  });
}
