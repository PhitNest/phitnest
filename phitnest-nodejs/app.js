const express = require("express");
const bodyParser = require("body-parser");
const { Server } = require("socket.io");
const { createAdapter } = require("@socket.io/redis-adapter");
const morgan = require("morgan");
const routes = require("./lib/routes");
require("dotenv").config();

module.exports = {
  createApp: (redisClient) => {
    const app = express();

    app.use((req, res, next) => {
      res.locals.redis = redisClient;
      next();
    });

    app.use(morgan("dev"));

    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({ extended: false }));

    app.get("/", (req, res) => {
      res
        .status(200)
        .json({ resultMessage: "Requests are working successfully..." });
    });
    app.use("/", routes);
    return app;
  },
  createSocketIO: (pubClient, subClient, server) => {
    const io = new Server(server);

    io.use((socket, next) => {
      try {
        const data = jwt.verify(
          socket.handshake.headers.authorization,
          JWT_SECRET
        );
        socket.data.userId = data._id;
        socket.data.redis = pubClient;
        next();
      } catch (error) {
        next(error);
      }
    });

    io.adapter(createAdapter(pubClient, subClient));
    return io;
  },
};
