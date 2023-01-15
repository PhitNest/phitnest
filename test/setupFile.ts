import {
  getDatabase,
  injectAdapters,
} from "../src/framework/adapters/injection";
import {
  injectCaches,
  injectDatabases,
} from "../src/data/data-sources/injection";

beforeAll(async () => {
  injectAdapters();
  injectDatabases();
  injectCaches();
  await getDatabase().connect(process.env.MONGODB_CONN_STRING ?? "");
});

afterAll(async () => {
  const db = getDatabase();
  await db.dropDatabase();
  await db.disconnect();
});
