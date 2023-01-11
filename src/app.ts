import { getDatabase, getServer, injectAdapters } from "./adapters/injection";
import { injectRepositories } from "./repositories/injection";
import { buildRouter } from "./router";

export async function start() {
  injectAdapters();
  injectRepositories();
  const database = getDatabase();
  await database.connect(
    process.env.MONGODB_CONN_STRING ?? "mongodb://localhost:27017"
  );
  const server = getServer();
  buildRouter(server);
  await server.listen(parseInt(process.env.PORT ?? "3000"));
}

export async function stop() {
  const server = getServer();
  const database = getDatabase();
  await server.close();
  await database.disconnect();
}
