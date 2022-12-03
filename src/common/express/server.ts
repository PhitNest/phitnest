import bodyParser from "body-parser";
import express from "express";
import http from "http";
import { queryParser } from "express-query-parser";
import morgan from "morgan";
import { l } from "../logger";
import { buildRoutes } from "./routes";
import path from "path";
import fs from "fs";

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
  if (process.env.NODE_ENV != "production") {
    const root = path.normalize(__dirname + "/../../..");
    app.set("appPath", root + "client");
    app.use(express.static(`${root}/public`));
    const files = fs.readdirSync(`${root}/openapi/specs`);
    for (let i = 0; i < files.length; i++) {
      app.use(
        `/specs/${files[i]}`,
        express.static(`${root}/openapi/specs/${files[i]}`)
      );
    }
    const apiSpec = `${root}/openapi/api.yml`;
    app.use("/spec", express.static(apiSpec));
  } else {
    app.use("/", (req, res) => res.status(200).send());
  }
  server = http.createServer(app);
  return server;
}

export function stopServer() {
  return server.close();
}
