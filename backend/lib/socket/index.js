const registerConversations = require('./conversation');
const registerMessages = require('./message');

module.exports = (socket) => {
  registerConversations(socket);
  registerMessages(socket);
};
