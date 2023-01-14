import dotenv from "dotenv";
dotenv.config();
import {
  getSocketServer,
  getServer,
  getDatabase,
  injectAdapters,
} from "./adapters/injection";
import { injectRepositories } from "./repositories/injection";
import { buildRouter } from "./router";

injectAdapters();
injectRepositories();
getDatabase()
  .connect(process.env.MONGODB_CONN_STRING ?? "mongodb://localhost:27017")
  .then(() => {
    const server = getServer();
    buildRouter(server);
    server.listen(parseInt(process.env.PORT ?? "3000")).then((httpServer) => {
      getSocketServer().listen(httpServer);
    });
  });
