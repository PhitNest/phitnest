const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const JWT = require('jsonwebtoken');
const errorJson = require('./utils/error');
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
app.use((req, res, next) => {
	res.header('Access-Control-Allow-Origin', '*');
	res.header('Access-Control-Allow-Headers',
		'Origin, X-Requested-With, Content-Type, Accept, Authorization');
	res.header('Content-Security-Policy-Report-Only', 'default-src: https:');
	if (req.method === 'OPTIONS') {
		res.header('Access-Control-Allow-Methods', 'PUT POST PATCH DELETE, GET');
		return res.status(200).json({});
	}
	next();
});

app.use((error, req, res, next) => {
	res.status(error.status || 500);
	if (res.status === 500) {
		res.json({
			resultMessage: { msg: error.message }
		})
	} else if (error.status === 404) {
		res.json({
			resultMessage: { msg: error.message }
		})
	} else {
		res.json(errorJson(error.message, 'External Error'));

	}
});

const server = http.createServer(app);
const io = new Server(server);
mongoose.db();

io.use((socket, next) => {
	try {
		const data = JWT.verify(socket.handshake.headers.auth, process.env.JWT_SECRET);
		socket.data.userId = data._id;
		next();
	} catch (error) {
		next(error);
	}
});

const { registerListeners, registerEmitters } = require('./api/sockets');

registerEmitters(io);
io.on('connection', registerListeners);

server.listen(PORT, () => console.log(`Server is running on ${PORT}`));