const NodeEnvironment = require('jest-environment-node').default;
const { MongoMemoryServer } = require('mongodb-memory-server');
const { createUser, createConversation } = require('../lib/models');
const Redis = require('ioredis-mock');
const jwt = require('jsonwebtoken');
const { createApp } = require('../app');
const mongoose = require('mongoose');
require('dotenv').config();

const users = [
  {
    _id: new mongoose.Types.ObjectId(),
    email: 'a@a.com',
    password: '$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne',
    firstName: 'John',
    mobile: '7577481869',
    birthday: Date.UTC(2000, 1, 1),
    lastSeen: Date.now(),
  },
  {
    _id: new mongoose.Types.ObjectId(),
    email: 'a@b.com',
    password: '$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne',
    firstName: 'Joe',
    mobile: '7577481868',
    birthday: Date.UTC(2000, 1, 1),
    lastSeen: Date.now(),
  },
  {
    _id: new mongoose.Types.ObjectId(),
    email: 'a@c.com',
    password: '$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne',
    firstName: 'Jack',
    mobile: '7577481860',
    birthday: Date.UTC(2000, 1, 1),
    lastSeen: Date.now(),
  },
];

const conversations = [
  {
    name: 'testConvo',
    participants: [users[0]._id, users[1]._id],
  },
  {
    name: 'testConvo2',
    participants: [users[1]._id, users[2]._id],
  },
  {
    name: 'testGroupChat',
    participants: users.map((user) => user._id),
  },
];

class BaseEnvironment extends NodeEnvironment {
  async setup() {
    await super.setup();
    this.global.jwtSecret = process.env.JWT_SECRET;
    this.mongoServer = await MongoMemoryServer.create();
    await mongoose.connect(this.mongoServer.getUri());
    this.global.redis = new Redis();
    this.global.app = createApp(this.global.redis);
    this.users = await Promise.all(
      users.map((user) =>
        createUser(user).then(
          (userModel) => {
            (userModel.jwt = jwt.sign(
              { _id: userModel._id },
              this.global.jwtSecret,
              {
                expiresIn: '2h',
              }
            ));
            return userModel;
          }
        )
      )
    );

    this.conversations = await Promise.all(
      conversations.map((conversation) => createConversation(conversation))
    );

    this.global.data = {
      users: this.users,
      conversations: this.conversations,
    };
  }

  async teardown() {
    if (this.mongoServer) {
      await mongoose.disconnect();
    }
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
