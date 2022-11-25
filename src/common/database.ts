import mongoose from "mongoose";
import { l } from "./logger";

export function connect() {
  return new Promise<void>((resolve, reject) => {
    mongoose.connect(process.env.MONGODB_CONN_STRING!, (err) => {
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

export async function disconnect() {
  l.info(`Disconnected from MongoDB`);
  await mongoose.disconnect();
}
