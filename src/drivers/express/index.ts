import express from "express";
import morgan from "morgan";
import bodyParser from "body-parser";

/**
 * Use this for injecting dependencies and building the router
 */
export { buildRouter } from "./routes";

/**
 * This will build the express application
 */
export function createApp() {
  const app = express();
  app.use(morgan("dev"));
  app.use(bodyParser.json());
  return app;
}
