import bodyParser from "body-parser";
import express from "express";
import http from "http";
import morgan from "morgan";
import { l } from "../logger";
import { dependencies } from "../dependency-injection";
import { buildRoutes } from "./routes";

let server: http.Server;

export function createServer() {
  const app = express();
  app.use(bodyParser.json());
  app.use(morgan("dev"));
  app.use(buildRoutes(dependencies));
  server = http.createServer(app);
  return new Promise((resolve) => {
    server.listen(process.env.PORT, () => {
      l.info(`Server started on port: ${process.env.PORT}`);
      resolve(server);
    });
  });
}

export function stopServer() {
  return server.close();
}
