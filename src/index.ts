import dotenv from "dotenv";
dotenv.config();
import {
  getSocketServer,
  getServer,
  getDatabase,
  injectAdapters,
} from "./framework/adapters/injection";
import { injectCaches, injectDatabases } from "./data/data-sources/injection";
import { buildRouter } from "./framework/routes";
import { bindEvents } from "./framework/events";

// Dependency injection
injectAdapters();
injectDatabases();
injectCaches();

// Connect to database
getDatabase()
  .connect(process.env.MONGODB_CONN_STRING ?? "mongodb://localhost:27017")
  .then(() => {
    const server = getServer();
    const socketServer = getSocketServer();
    bindEvents(socketServer);
    buildRouter(server);
    server.listen(parseInt(process.env.PORT ?? "3000")).then((httpServer) => {
      socketServer.listen(httpServer);
    });
  });
