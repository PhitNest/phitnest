const registerListeners = require("./lib/socket");
const { createApp, createSocketIO } = require("./app");
const Redis = require("ioredis");
const { createServer } = require("http");
const mongoose = require("mongoose");
require("dotenv").config();
const PORT = process.env.PORT || 3000;
const DB = process.env.DB || "mongodb://localhost:27017/";

mongoose.connect(DB);

const redisClient = new Redis();
const subClient = redisClient.duplicate();
const app = createApp(redisClient);
const server = createServer(app);
const io = createSocketIO(redisClient, subClient, server);

io.on("connection", (socket) => {
  registerListeners(socket);
});

server.listen(PORT, () => console.log(`Server is running on ${PORT}`));
