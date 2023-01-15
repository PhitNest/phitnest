import dotenv from "dotenv";
dotenv.config();
import {
  getSocketServer,
  getServer,
  getDatabase,
  injectAdapters,
} from "./framework/adapters/injection";
import { injectDataSources } from "./data/data-sources/injection";
import { buildRouter } from "./framework/router";

injectAdapters();
injectDataSources();
getDatabase()
  .connect(process.env.MONGODB_CONN_STRING ?? "mongodb://localhost:27017")
  .then(() => {
    const server = getServer();
    buildRouter(server);
    server.listen(parseInt(process.env.PORT ?? "3000")).then((httpServer) => {
      getSocketServer().listen(httpServer);
    });
  });
