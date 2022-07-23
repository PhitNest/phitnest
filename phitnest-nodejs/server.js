const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const JWT = require('jsonwebtoken');
const mongoose = require('./api/middleware/db');
const rateLimiter = require('./api/middleware/rateLimiter');
const routes = require('./api/routes');
const { Server } = require("socket.io");
const http = require('http');
require('dotenv').config();

process.on('uncaughtException', error => {
	console.log(error);
});

process.on('unhandledRejection', error => {
	console.log(error);
});

const PORT = process.env.port || 3000;

const app = express();

app.use(morgan('dev'));
app.use(rateLimiter);

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.set('trust proxy', true);

app.get('/', (req, res) => {
	res.status(200).json({ resultMessage: 'Requests are working successfully...' });
});
app.use('/', routes);

const server = http.createServer(app);
const io = new Server(server);
mongoose.db();

io.use((socket, next) => {
	try {
		const data = JWT.verify(socket.handshake.headers.authorization, process.env.JWT_SECRET);
		socket.data.userId = data._id;
		next();
	} catch (error) {
		next(error);
	}
});

const { registerListeners, registerEmitters } = require('./api/sockets');

registerEmitters.broadcasts(io);
io.on('connection', socket => {
	registerEmitters.socket(socket);
	registerListeners(socket);
});

server.listen(PORT, () => console.log(`Server is running on ${PORT}`));