const express = require('express');
const http = require('http');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const { Server } = require('socket.io')
const { createAdapter } = require("@socket.io/redis-adapter");
const { createClient } = require("redis");
const routes = require('./lib/routes');
const jwt = require('jsonwebtoken');
const registerListeners = require('./lib/socket/listeners');
require('dotenv').config();

const PORT = process.env.port || 3000;
const app = express();

mongoose.connect(process.env.DB);

const pubClient = createClient(process.env.REDIS_PORT, process.env.REDIS_HOST);
const subClient = pubClient.duplicate();
pubClient.connect();
subClient.connect();

app.use((req, res, next) => {
    res.locals.redis = pubClient;
    next();
});

app.use(morgan('dev'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', (req, res) => {
    res.status(200).json({ resultMessage: 'Requests are working successfully...' });
});
app.use('/', routes);

const server = http.createServer(app);
const io = new Server(server);
io.adapter(createAdapter(pubClient, subClient));

io.use((socket, next) => {
    try {
        const data = jwt.verify(socket.handshake.headers.authorization, process.env.JWT_SECRET);
        socket.data.userId = data._id;
        socket.data.redis = pubClient;
        next();
    } catch (error) {
        next(error);
    }
});

io.on('connection', socket => {
    registerListeners(socket);
});

server.listen(PORT, () => console.log(`Server is running on ${PORT}`));