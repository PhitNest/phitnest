const user = require('./user');
const message = require('./message');
const conversation = require('./conversation');
const gym = require('./gym');
const admin = require('./admin');

module.exports = {
  ...user,
  ...message,
  ...conversation,
  ...gym,
  ...admin,
};
