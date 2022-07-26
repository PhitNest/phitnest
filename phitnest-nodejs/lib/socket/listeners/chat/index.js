const sendMessage = require('./sendMessage');
const joinConversations = require('./joinConversations');

module.exports = socket => {
    sendMessage(socket);
    joinConversations(socket);
}