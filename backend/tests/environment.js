const NodeEnvironment = require('jest-environment-node').default;
const Redis = require('ioredis-mock');
const { createExpressApp } = require('../app');
require('dotenv').config();

class BaseEnvironment extends NodeEnvironment {
  async setup() {
    await super.setup();
    this.global.jwtSecret = process.env.JWT_SECRET;
    this.global.redis = new Redis();
    this.global.app = createExpressApp(this.global.redis);
  }

  async teardown() {
    if (this.global.redis) {
      await this.global.redis.flushall();
    }

    await super.teardown();
  }

  getVmContext() {
    return super.getVmContext();
  }
}

module.exports = BaseEnvironment;
