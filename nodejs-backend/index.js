const { createExpressApp, createSocketIO } = require('./app');
const Redis = require('ioredis');
const { createAdapter } = require('@socket.io/redis-adapter');
const http = require('http');
require('dotenv').config();

const PORT = process.env.PORT || 3000;

const REDIS_HOST = process.env.REDIS_HOST || 'localhost';
const REDIS_PORT = process.env.REDIS_PORT || 6379;
const REDIS_PASSWORD = process.env.REDIS_PASSWORD || '';

const redisClient = new Redis(REDIS_PORT, REDIS_HOST, { password: REDIS_PASSWORD });
const subClient = redisClient.duplicate();

const app = createExpressApp(redisClient);
const server = http.createServer(app);

const io = createSocketIO(server);

io.adapter(createAdapter(redisClient, subClient));

server.listen(PORT, () => console.log(`Server is running on ${PORT}`));
