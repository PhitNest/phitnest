const { createApp, createSocketIO } = require('./app');
const Redis = require('ioredis');
const { createAdapter } = require('@socket.io/redis-adapter');
const { createServer } = require('http');
const mongoose = require('mongoose');
const registerListeners = require('./lib/socket');
require('dotenv').config();
const PORT = process.env.PORT || 3000;
const DB = process.env.DB || 'mongodb://localhost:27017/';
const REDIS_PASSWORD = process.env.REDIS_PASSWORD || '';
const REDIS_HOST = process.env.REDIS_HOST || 'localhost';
const REDIS_PORT = process.env.REDIS_PORT || 6379;

mongoose.connect(DB);

const redisClient = new Redis(REDIS_PORT, REDIS_HOST, {
  password: REDIS_PASSWORD,
});
const subClient = redisClient.duplicate();
const app = createApp(redisClient);
const server = createServer(app);
const io = createSocketIO(server);
io.on('connection', (socket) => {
  socket.data.redis = redisClient;
  registerListeners(socket);
});
io.adapter(createAdapter(redisClient, subClient));

server.listen(PORT, () => console.log(`Server is running on ${PORT}`));
