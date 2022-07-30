const { createApp } = require("../../app");
const BaseEnvironment = require("../environment");

class RestEnvironment extends BaseEnvironment {
  async setup() {
    await super.setup();
    this.global.app = createApp(this.global.redis);
  }
}

module.exports = RestEnvironment;
