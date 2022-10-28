import express from "express";
import { Application } from "express";
import path from "path";
import http from "http";
import os from "os";
import l from "./logger";
import fs from "fs";
import morgan from "morgan";
import { IDatabase } from "./database";
import { registerSocketIO } from "./socket";
import errorHandler from "../src/middlewares/error.middleware";
import * as OpenApiValidator from "express-openapi-validator";

const app = express();

export default class ExpressServer {
  constructor() {
    const root = path.normalize(__dirname + "/../..");
    app.set("appPath", root + "client");
    app.use(morgan("dev"));
    app.use(express.json({ limit: process.env.REQUEST_LIMIT || "100kb" }));
    app.use(
      express.urlencoded({
        extended: true,
        limit: process.env.REQUEST_LIMIT || "100kb",
      })
    );
    app.use(express.text({ limit: process.env.REQUEST_LIMIT || "100kb" }));
    app.use(express.static(`${root}/public`));

    const files = fs.readdirSync(`${root}/openapi/specs`);
    for (let i = 0; i < files.length; i++) {
      app.use(
        `/specs/${files[i]}`,
        express.static(`${root}/openapi/specs/${files[i]}`)
      );
    }

    const apiSpec = `${root}/openapi/api.yml`;
    const validateResponses = !!(
      process.env.OPENAPI_ENABLE_RESPONSE_VALIDATION &&
      process.env.OPENAPI_ENABLE_RESPONSE_VALIDATION.toLowerCase() === "true"
    );
    app.use("/spec", express.static(apiSpec));
    app.use(
      OpenApiValidator.middleware({
        apiSpec,
        validateResponses,
        ignorePaths: /.*\/spec(\/|$)/,
      })
    );
  }

  router(routes: (app: Application) => void): ExpressServer {
    routes(app);
    app.use(errorHandler);
    return this;
  }

  database(db: IDatabase): ExpressServer {
    db.init();
    return this;
  }

  listen(port: number): Application {
    const welcome = (p: number) => (): void =>
      l.info(
        `up and running in ${
          process.env.NODE_ENV || "development"
        } @: ${os.hostname()} on port: ${p}}`
      );
    registerSocketIO(http.createServer(app).listen(port, welcome(port)));
    return app;
  }
}
