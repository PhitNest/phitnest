const joinConversations = require('./joinConversations');

module.exports = (socket) => {
  joinConversations(socket);
};
