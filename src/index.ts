import { getEnv } from "./common/env";
import { createApp } from "./drivers/express";
import l from "./common/logger";
import http from "http";
import { injectDependencies } from "./dependencies";
import mongoose from "mongoose";

/**
 * This is the entry point of the app. This will initialize all drivers/services.
 */
mongoose.connect(getEnv().MONGODB_CONN_STRING, (err) => {
  if (err) {
    l.error(`Failed to connect to MongoDB: ${err}`);
  } else {
    l.info(`Connected to MongoDB`);
  }
  const app = createApp();
  injectDependencies(app);
  const server = http.createServer(app).listen(getEnv().PORT, () => {
    l.info(`Opened express server on port ${getEnv().PORT}`);
  });
});
