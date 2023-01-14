import { MongoMemoryServer } from "mongodb-memory-server";
import mongoose from "mongoose";

export async function startMockServer() {
  const memoryDb = await MongoMemoryServer.create();
  const uri = memoryDb.getUri();
  (global as any).__MONGOINSTANCE = memoryDb;
  process.env.MONGODB_CONN_STRING = uri;
  await mongoose.connect(uri);
  await mongoose.connection.db.dropDatabase();
  await mongoose.disconnect();
}

export async function stopMockServer() {
  const memoryDb: MongoMemoryServer = (global as any).__MONGOINSTANCE;
  await memoryDb.stop();
}
