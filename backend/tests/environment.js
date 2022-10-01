const NodeEnvironment = require('jest-environment-node').default;
const Redis = require('ioredis-mock');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const { createExpressApp } = require('../app');
require('dotenv').config();

class BaseEnvironment extends NodeEnvironment {
  async setup() {
    await super.setup();
    this.global.jwtSecret = process.env.JWT_SECRET;
    this.mongoServer = await MongoMemoryServer.create();
    await mongoose.connect(this.mongoServer.getUri());
    this.redis = new Redis();
    this.global.app = createExpressApp(this.redis);
  }

  async teardown() {
    if (this.mongoServer) {
      await mongoose.disconnect();
    }
    if (this.redis) {
      await this.redis.flushall();
    }

    await super.teardown();
  }

  getVmContext() {
    return super.getVmContext();
  }
}

module.exports = BaseEnvironment;
