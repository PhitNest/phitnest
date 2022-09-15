const BaseEnvironment = require('../../environment');

const users = [
  {
    email: 'a@a.com',
    firstName: 'Joe',
    lastName: 'A',
    password: '$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne',
  },
  {
    email: 'a@b.com',
    firstName: 'Joe',
    lastName: 'B',
    password: '$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne',
  },
  {
    email: 'a@c.com',
    firstName: 'Joe',
    lastName: 'C',
    password: '$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne',
  },
];

class AuthEnvironment extends BaseEnvironment {
  async setup() {
    await super.setup();
    const transaction = this.global.redis.multi();
    for (let i = 0; i < users.length; i++) {
      transaction
        .hset(`users:${i}`, users[i])
        .hset(`users:emails:${users[i].email}`, {
          id: i,
          password: users[i].password,
        });
    }
    await transaction.exec();
  }
}

module.exports = AuthEnvironment;
