const BaseEnvironment = require('../environment');
const Client = require('socket.io-client');
const { createServer } = require('http');
const { createSocketIO } = require('../../app');
const registerListeners = require('../../lib/socket');
const Q = require('q');
require('dotenv').config();

class SocketEnvironment extends BaseEnvironment {
  async setup() {
    await super.setup();
    this.server = createServer(this.global.app);
    this.global.io = createSocketIO(this.server);
    let deffered = Q.defer();
    this.server.listen(process.env.PORT, () => {
      let numConnections = 0;
      this.global.io.on('connection', (socket) => {
        socket.data.redis = this.global.redis;
        registerListeners(socket);
        numConnections++;
        if (numConnections === this.users.length) {
          deffered.resolve();
        }
      });
      for (let i = 0; i < this.users.length; i++) {
        this.users[i].client = Client(`http://localhost:${process.env.PORT}`, {
          extraHeaders: {
            Authorization: this.users[i].jwt
          },
        });
      }
    });
    await deffered.promise;
    this.global.data.users = this.users;
  }

  async teardown() {
    this.global.io.close();
    for (let i = 0; i < this.users.length; i++) {
      this.users[i].client.close();
    }
    await super.teardown();
  }
}

module.exports = SocketEnvironment;
