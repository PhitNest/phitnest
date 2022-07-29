const NodeEnvironment = require("jest-environment-node").default;
const { MongoMemoryServer } = require("mongodb-memory-server");
const redis = require("redis");
const mongoose = require("mongoose");
require("dotenv").config();

class BaseEnvironment extends NodeEnvironment {
  async setup() {
    await super.setup();
    this.global.jwtSecret = process.env.JWT_SECRET;
    this.mongoServer = await MongoMemoryServer.create();
    await mongoose.connect(this.mongoServer.getUri());
    this.global.redis = redis.createClient();
    await this.global.redis.connect();
  }

  async teardown() {
    if (this.mongoServer) {
      await mongoose.disconnect();
    }
    if (this.global.redis.connected) {
      await this.global.redis.flushall();
      await this.global.redis.disconnect();
    }
    await super.teardown();
  }

  getVmContext() {
    return super.getVmContext();
  }
}

module.exports = BaseEnvironment;
