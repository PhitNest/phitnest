import mongoose from "mongoose";
import { getEnv } from "./env";
import { l } from "./logger";

export function connect() {
  return new Promise<void>((resolve, reject) => {
    mongoose.connect(getEnv().MONGODB_CONN_STRING, (err) => {
      if (err) {
        l.error(`Failed to connect to MongoDB: ${err}`);
        reject(new Error(err.message));
      } else {
        l.info(`Connected to MongoDB`);
        resolve();
      }
    });
  });
}
