import { MongoMemoryServer } from "mongodb-memory-server";

export default async function () {
  const memoryDb: MongoMemoryServer = (global as any).__MONGOINSTANCE;
  await memoryDb.stop();
}
