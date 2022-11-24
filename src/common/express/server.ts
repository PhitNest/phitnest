import bodyParser from "body-parser";
import express, { Router } from "express";
import http from "http";
import morgan from "morgan";
import { HttpMethod, IRouter } from "../../routers/types";
import { getEnv } from "../env";
import { buildController } from "./controller";
import { buildMiddleware } from "./middleware";
import { l } from "../logger";
import { GymRouter } from "../../routers";
import { dependencies } from "../dependency-injection";

export function createServer() {
  const app = express();
  app.use(bodyParser.json());
  app.use(morgan("dev"));
  app.use(buildRoutes());
  const server = http.createServer(app);
  return new Promise((resolve) => {
    server.listen(getEnv().PORT, () => {
      l.info(`Server started on port: ${getEnv().PORT}`);
      resolve(server);
    });
  });
}

function buildRoutes() {
  const router = Router();
  buildRoute(router, dependencies.resolve(GymRouter));
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
