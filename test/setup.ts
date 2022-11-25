import { MongoMemoryServer } from "mongodb-memory-server";
import mongoose from "mongoose";
import dotenv from "dotenv";
dotenv.config();

export default async function () {
  const memoryDb = await MongoMemoryServer.create();
  const uri = memoryDb.getUri();
  (global as any).__MONGOINSTANCE = memoryDb;
  process.env.MONGODB_CONN_STRING = uri;
  await mongoose.connect(uri);
  await mongoose.connection.db.dropDatabase();
  await mongoose.disconnect();
}
