import { createApp } from "./drivers/express";
import "./common/env";
import l from "./common/logger";
import http from "http";
import { injectDependencies } from "./dependencies";
import mongoose from "mongoose";

const CONN_STRING =
  process.env.MONGODB_CONN_STRING || "mongodb://127.0.0.1:27017/dev";

const PORT = process.env.PORT || 3000;

/**
 * This is the entry point of the app. This will initialize all drivers/services.
 */
mongoose.connect(CONN_STRING, (err) => {
  if (err) {
    l.error(`Failed to connect to MongoDB: ${err}`);
  } else {
    l.info(`Connected to MongoDB`);
  }
  const app = createApp();
  injectDependencies(app);
  const server = http.createServer(app).listen(PORT, () => {
    l.info(`Opened express server on port ${PORT}`);
  });
});
