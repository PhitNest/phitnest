const sendMessage = require('./sendMessage');

module.exports = (socket) => {
  sendMessage(socket);
};
