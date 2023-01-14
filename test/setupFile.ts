import { getDatabase, injectAdapters } from "../src/adapters/injection";
import { injectRepositories } from "../src/repositories/injection";

beforeAll(async () => {
  injectAdapters();
  injectRepositories();
  await getDatabase().connect(process.env.MONGODB_CONN_STRING ?? "");
});

afterAll(async () => {
  const db = getDatabase();
  await db.dropDatabase();
  await db.disconnect();
});
