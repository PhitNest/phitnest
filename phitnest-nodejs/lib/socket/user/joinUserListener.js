const { userModel } = require('../../models');

module.exports = (socket) =>
  userModel
    .findById(socket.data.userId)
    .then((user) => socket.join(`userListener:${user._id}`));
