import bodyParser from "body-parser";
import express from "express";
import http from "http";
import { queryParser } from "express-query-parser";
import morgan from "morgan";
import { l } from "../logger";
import { buildRoutes } from "./routes";
import {
  statusInternalServerError,
  statusOK,
} from "../../constants/http_codes";

let server: http.Server;

export function listen() {
  return new Promise((resolve) => {
    server.listen(process.env.PORT, () => {
      l.info(`Server started on port: ${process.env.PORT}`);
      resolve(server);
    });
  });
}

export function createServer() {
  const app = express();
  app.use(bodyParser.json());
  app.use(
    queryParser({
      parseNull: true,
      parseBoolean: true,
      parseNumber: true,
    })
  );
  app.use(morgan("dev"));
  app.use(buildRoutes());
  app.use(
    (
      err: any,
      req: express.Request,
      res: express.Response,
      next: express.NextFunction
    ) => {
      res.status(statusInternalServerError).json({ message: err });
    }
  );
  app.get("/", (req, res) => res.status(statusOK).send());
  server = http.createServer(app);
  return server;
}

export function stopServer() {
  return server.close();
}
