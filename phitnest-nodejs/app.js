const express = require('express');
const bodyParser = require('body-parser');
const { Server } = require('socket.io');
const morgan = require('morgan');
const routes = require('./lib/routes');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
require('dotenv').config();

module.exports = {
  createApp: (redisClient) => {
    const app = express();

    app.use((req, res, next) => {
      res.locals.redis = redisClient;
      next();
    });

    app.use(morgan('dev'));

    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({ extended: false }));

    app.get('/', (req, res) => {
      res
        .status(200)
        .json({ resultMessage: 'Requests are working successfully...' });
    });
    app.use('/', routes);
    return app;
  },
  createSocketIO: (server) => {
    const io = new Server(server);

    io.use((socket, next) => {
      try {
        const data = jwt.verify(
          socket.handshake.headers.authorization,
          process.env.JWT_SECRET
        );
        socket.data.userId = mongoose.Types.ObjectId(data._id);
        next();
      } catch (error) {
        next(error);
      }
    });

    return io;
  },
};
